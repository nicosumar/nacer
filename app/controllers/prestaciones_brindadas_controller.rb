# -*- encoding : utf-8 -*-
class PrestacionesBrindadasController < ApplicationController
  before_filter :authenticate_user!

  # GET /prestaciones_brindadas
  def index
    # Verificar los permisos del usuario
    if cannot? :read, PrestacionBrindada
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Preparar los objetos necesarios para la vista
    @estados_de_las_prestaciones =
      [["En cualquier estado", nil]] +
      EstadoDeLaPrestacion.find(:all, :order => :id).collect{ |e| ["En estado '" + e.nombre + "'", e.id] }

    # Verificar si hay un parámetro para filtrar las novedades
    if params[:estado_de_la_prestacion_id].blank?
      # No hay filtro, devolver todas las prestaciones brindadas
      @prestaciones_brindadas =
        PrestacionBrindada.paginate( :page => params[:page], :per_page => 20, :include => [:prestacion, :diagnostico],
          :order => "updated_at DESC"
        )
      @estado_de_la_prestacion_id = nil
      @descripcion_del_estado = 'registradas'
    else
      @estado_de_la_prestacion_id = params[:estado_de_la_prestacion_id].to_i
      # Verificar que el parámetro sea un estado válido
      if @estado_de_la_prestacion_id && !@estados_de_las_prestaciones.collect{|i| i[1]}.member?(@estado_de_la_prestacion_id)
        redirect_to(root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
           :mensaje => "Se informará al administrador del sistema sobre este incidente."
          }
        )
        return
      end
      @descripcion_del_estado = EstadoDeLaPrestacion.find(@estado_de_la_prestacion_id).nombre

      # Obtener las novedades filtradas de acuerdo con el parámetro
      @prestaciones_brindadas =
        PrestacionBrindada.con_estado(@estado_de_la_prestacion_id).paginate(:page => params[:page], :per_page => 20,
          :include => [:prestacion, :diagnostico], :order => "updated_at DESC"
        )

      @mostrar_efector = (UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual]).efectores.size > 1)
    end

  end

  # GET /prestaciones_brindadas/:id
  def show
    # Verificar los permisos del usuario
    if cannot? :read, PrestacionBrindada
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener la prestación solicitada
    begin
      @prestacion_brindada =
        PrestacionBrindada.find(params[:id],
          :include => [
            :estado_de_la_prestacion, {:prestacion => :unidad_de_medida}, :efector, :diagnostico, :datos_reportables_asociados
          ]
        )
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La prestación solicitada no existe",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar si hay advertencias
    @prestacion_brindada.hay_advertencias?

    # Obtener el afiliado o la novedad asociadas a la prestación
    @beneficiario =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => @prestacion_brindada.clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:pendiente => true),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not @beneficiario
      @beneficiario = Afiliado.find_by_clave_de_beneficiario(@prestacion_brindada.clave_de_beneficiario)
    end

  end


  # GET /prestaciones_brindadas/new
  def new
    # Verificar los permisos del usuario
    if cannot? :create, PrestacionBrindada
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Si no se han pasado parámetros para esta ruta, debe iniciarse el procedimiento con una búsqueda de beneficiario
    if !params[:clave_de_beneficiario] && !params[:prestacion_brindada] && !params[:terminos]
      @terminos = nil
      @resultados_de_la_busqueda = []
      flash.delete :tipo
      render "new_busqueda"
      return
    end

    # Si se pasa el parámetro ":terminos", es que ya se ha iniciado la búsqueda, debemos mostrar los resultados
      # Realizar la búsqueda de los beneficiarios
    if params[:terminos]
      @terminos = params[:terminos]
      if @terminos.blank?
        redirect_to(
          new_prestacion_brindada_path,
          :flash => {:tipo => :error, :titulo => "Debe ingresar uno o más términos para buscar"}
        )
        return
      end

      # Preparar los resultados de la búsqueda en la vista temporal
      inicio = Time.now()
      Busqueda.busqueda_fts(@terminos, :solo => [:afiliados, :novedades_de_los_afiliados])

      # Eliminar los resultados a cuyos modelos el usuario no tiene acceso
      indices = []
      ObjetoEncontrado.find(:all).each do |o|
        if can? :read, eval(o.modelo_type)
          indices << o.id
        end
      end

      @registros_coincidentes = indices.size

      if @registros_coincidentes > 0
        @resultados_de_la_busqueda =
          ResultadoDeLaBusqueda.where('id IN (?)', indices).order('orden ASC').paginate(:page => params[:page], :per_page => 20)
      end
      fin = Time.now()
      @tiempo_de_busqueda = fin - inicio

      render "new_busqueda"
      return
    end

    # Obtener la novedad o el afiliado asociado a la clave
    @beneficiario =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => (params[:clave_de_beneficiario] || params[:prestacion_brindada][:clave_de_beneficiario]),
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:pendiente => true),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if !@beneficiario
      @beneficiario =
        Afiliado.find_by_clave_de_beneficiario(
          params[:clave_de_beneficiario] || params[:prestacion_brindada][:clave_de_beneficiario]
        )
    end

    if !@beneficiario
      redirect_to(
        root_url,
        :flash => {:tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Esta acción se ejecuta en dos partes. La inicial fija el efector y la fecha de la prestación, y la segunda define el resto
    # de los datos.
    if !params[:commit]
      # Preparar los objetos para la vista de la primer etapa (selección de efector y fecha)
      @prestacion_brindada = PrestacionBrindada.new
      @prestacion_brindada.clave_de_beneficiario = @beneficiario.clave_de_beneficiario
      @efectores = UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual]).efectores.order(:nombre).collect{
        |e| [e.cuie + " - " + e.nombre, e.id]
      }
      if @efectores.size == 1
        # Fijar el efector si la UAD solo tiene asociado un efector para facturación
        @prestacion_brindada.efector_id = @efectores.first[1]
      else
        @prestacion_brindada.efector_id = nil
      end
      render :action => "efector_y_fecha"
      return
    else
      # Crear el objeto desde los parámetros y verificar si está correcto
      @prestacion_brindada = PrestacionBrindada.new(params[:prestacion_brindada])
      @prestacion_brindada.estado_de_la_prestacion_id = EstadoDeLaPrestacion.id_del_codigo("I")

      # Verificar si no hay errores en la selección de efector y fecha
      if !@prestacion_brindada.verificacion_correcta?
        # Recrear los objetos para presentar nuevamente el formulario con los errores
        @efectores = UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual]).efectores.order(:nombre).collect{
          |e| [e.cuie + " - " + e.nombre, e.id]
        }
        if @efectores.size == 1
          @prestacion_brindada.efector_id = @efectores.first[1]
        else
          @prestacion_brindada.efector_id = nil
        end
        render :action => "efector_y_fecha"
        return
      end
    end

    # Añadir un nuevo objeto DatoReportableAsociado para cada uno de los DatosReportables definidos
    #@prestacion_brindada.datos_reportables_asociados.build(
    #  DatoReportable.find(:all, :order => [:id, :orden_de_grupo]).collect{
    #    |dr| {:dato_reportable_id => dr.id}
    #  }
    #)

    # Generar el listado de prestaciones válidas para esta combinación de beneficiario / efector / fecha
    # TODO: eliminar esto luego de que finalice el periodo de gracia
    if ( Date.today < Date.new(2013, 6, 30) &&
         @prestacion_brindada.fecha_de_la_prestacion < @prestacion_brindada.efector.fecha_de_inicio_del_convenio_actual )
      autorizadas_por_efector =
        Prestacion.find(
          @prestacion_brindada.efector.prestaciones_autorizadas_al_dia(
            @prestacion_brindada.efector.fecha_de_inicio_del_convenio_actual
          ).collect{ |p| p.prestacion_id }
        )
    else
      autorizadas_por_efector =
        Prestacion.find(
          @prestacion_brindada.efector.prestaciones_autorizadas_al_dia(@prestacion_brindada.fecha_de_la_prestacion).collect{
            |p| p.prestacion_id
          }
        )
    end
    autorizadas_por_grupo =
      @beneficiario.grupo_poblacional_al_dia(@prestacion_brindada.fecha_de_la_prestacion).prestaciones_autorizadas
    autorizadas_por_sexo = @beneficiario.sexo.prestaciones_autorizadas
    @prestaciones =
      autorizadas_por_efector.keep_if{
          |p| autorizadas_por_sexo.member?(p) && autorizadas_por_grupo.member?(p)
        }.collect{ |p| [p.nombre_corto + " - " + p.codigo, p.id] }.sort
    @diagnosticos = []

    # Mostrar las advertencias que se puedan haber generado en la selección de efector y fecha
    if @prestacion_brindada.hay_advertencias?
      flash[:tipo] = :advertencia
      flash[:titulo] = "Advertencia"
      flash[:mensaje] = @prestacion_brindada.advertencias[:base]
    end
  end

  # GET /prestaciones_brindadas/:id/edit
  def edit
    # Verificar los permisos del usuario
    if cannot? :update, PrestacionBrindada
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener la prestación solicitada
    begin
      @prestacion_brindada =
        PrestacionBrindada.find(params[:id],
          :include => [
            :estado_de_la_prestacion, {:prestacion => :unidad_de_medida}, :efector, :diagnostico,
            {:datos_reportables_asociados => {:dato_reportable_requerido => :dato_reportable}}
          ]
        )
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La prestación solicitada no existe",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el afiliado o la novedad asociadas a la prestación
    @beneficiario =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => @prestacion_brindada.clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:pendiente => true),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if not @beneficiario
      @beneficiario = Afiliado.find_by_clave_de_beneficiario(@prestacion_brindada.clave_de_beneficiario)
    end

    # Generar el listado de diagnósticos válidos para la prestación
    @diagnosticos = @prestacion_brindada.prestacion.diagnosticos.collect{|d| [d.nombre_y_codigo, d.id]}.sort

  end

  # POST /prestaciones_brindadas
  def create
    # Verificar los permisos del usuario
    if cannot? :create, PrestacionBrindada
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que se hayan pasado los parámetros requeridos
    if !params[:prestacion_brindada] ||
       !params[:prestacion_brindada][:clave_de_beneficiario] ||
       !params[:prestacion_brindada][:fecha_de_la_prestacion] ||
       !params[:prestacion_brindada][:efector_id]
      redirect_to(
        root_url,
        :flash => {:tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Obtener la novedad o el afiliado asociado a la clave
    @beneficiario =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => params[:prestacion_brindada][:clave_de_beneficiario],
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:pendiente => true),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if !@beneficiario
      @beneficiario =
        Afiliado.find_by_clave_de_beneficiario(
          params[:prestacion_brindada][:clave_de_beneficiario]
        )
    end

    if !@beneficiario
      redirect_to(
        root_url,
        :flash => {:tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Crear el objeto desde los parámetros y verificar si está correcto
    @prestacion_brindada = PrestacionBrindada.new(params[:prestacion_brindada])

    # Marcar la prestación brindada como incompleta, hasta tanto se completen las validaciones.
    @prestacion_brindada.estado_de_la_prestacion_id = EstadoDeLaPrestacion.id_del_codigo("I")

    # Generar el listado de prestaciones válidas para esta combinación de beneficiario / efector / fecha
    # TODO: eliminar esto luego de que finalice el periodo de gracia
    if ( Date.today < Date.new(2013, 6, 30) &&
         @prestacion_brindada.fecha_de_la_prestacion < @prestacion_brindada.efector.fecha_de_inicio_del_convenio_actual )
      autorizadas_por_efector =
        Prestacion.find(
          @prestacion_brindada.efector.prestaciones_autorizadas_al_dia(
            @prestacion_brindada.efector.fecha_de_inicio_del_convenio_actual
          ).collect{ |p| p.prestacion_id }
        )
    else
      autorizadas_por_efector =
        Prestacion.find(
          @prestacion_brindada.efector.prestaciones_autorizadas_al_dia(@prestacion_brindada.fecha_de_la_prestacion).collect{
            |p| p.prestacion_id
          }
        )
    end
    autorizadas_por_grupo =
      @beneficiario.grupo_poblacional_al_dia(@prestacion_brindada.fecha_de_la_prestacion).prestaciones_autorizadas
    autorizadas_por_sexo = @beneficiario.sexo.prestaciones_autorizadas
    @prestaciones =
      autorizadas_por_efector.keep_if{
          |p| autorizadas_por_sexo.member?(p) && autorizadas_por_grupo.member?(p)
        }.collect{ |p| [p.nombre_corto + " - " + p.codigo, p.id] }.sort

    if @prestacion_brindada.prestacion
      @diagnosticos = @prestacion_brindada.prestacion.diagnosticos.collect{|d| [d.nombre_y_codigo, d.id]}.sort
    else
      @diagnosticos = []
    end

    # Verificar la validez del objeto
    if !@prestacion_brindada.valid?
      render :action => "new"
      return
    end

    # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
    if ( @prestacion_brindada.prestacion_id && !@prestaciones.collect{ |i| i[1] }.member?(@prestacion_brindada.prestacion_id) ||
         @prestacion_brindada.diagnostico_id && !@diagnosticos.collect{ |i| i[1] }.member?(@prestacion_brindada.diagnostico_id) )
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Registrar el usuario que realiza la creación
    @prestacion_brindada.creator_id = current_user.id
    @prestacion_brindada.updater_id = current_user.id
    @prestacion_brindada.datos_reportables_asociados.each do |dra|
      dra.creator_id = current_user.id
      dra.updater_id = current_user.id
    end

    # Verificar si hay advertencias presentes, para modificar el estado de la prestación
    if @prestacion_brindada.hay_advertencias?
      if !@prestacion_brindada.datos_reportables_incompletos
        @prestacion_brindada.estado_de_la_prestacion_id = EstadoDeLaPrestacion.id_del_codigo("F")
      end
    else
      @prestacion_brindada.estado_de_la_prestacion_id = EstadoDeLaPrestacion.id_del_codigo("R")
    end

    # Guardar la prestación y los datos reportables asociados
    @prestacion_brindada.save

    if @prestacion_brindada.hay_advertencias?
      redirect_to(@prestacion_brindada,
        :flash => { :tipo => :advertencia,
          :titulo => 'La prestación brindada se registró con advertencias',
          :mensaje => 'Intente corregir los problemas detectados para reducir los rechazos en la facturación.' }
      )
    else
      redirect_to(@prestacion_brindada,
        :flash => { :tipo => :ok, :titulo => 'La prestación brindada se registró correctamente' }
      )
    end
  end

  # PUT /addendas/:id
  def update
    # Verificar los permisos del usuario
    if cannot? :update, PrestacionBrindada
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener la prestación qe se va a actualizar
    begin
      @prestacion_brindada =
        PrestacionBrindada.find(params[:id],
          :include => [
            :estado_de_la_prestacion, {:prestacion => :unidad_de_medida}, :efector, :diagnostico,
            {:datos_reportables_asociados => {:dato_reportable_requerido => :dato_reportable}}
          ]
        )
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La prestación solicitada no existe",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener la novedad o el afiliado asociado a la clave
    @beneficiario =
      NovedadDelAfiliado.where(
        :clave_de_beneficiario => params[:prestacion_brindada][:clave_de_beneficiario],
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:pendiente => true),
        :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
      ).first
    if !@beneficiario
      @beneficiario =
        Afiliado.find_by_clave_de_beneficiario(
          params[:prestacion_brindada][:clave_de_beneficiario]
        )
    end

    # Verificar que se hayan pasado los parámetros requeridos
    if !params[:prestacion_brindada]
      redirect_to(
        root_url,
        :flash => {:tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    if !@beneficiario
      redirect_to(
        root_url,
        :flash => {:tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Actualizar los atributos de la prestación
    @prestacion_brindada.attributes = params[:prestacion_brindada]

    # Marcar la prestación brindada como incompleta, hasta tanto se completen las validaciones.
    @prestacion_brindada.estado_de_la_prestacion_id = EstadoDeLaPrestacion.id_del_codigo("I")

    # Generar el listado de diagnósticos válidos para esta prestación
    @diagnosticos = @prestacion_brindada.prestacion.diagnosticos.collect{|d| [d.nombre_y_codigo, d.id]}.sort

    # Verificar la validez del objeto
    if !@prestacion_brindada.valid?
      render :action => "edit"
      return
    end

    # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
    if ( @prestacion_brindada.diagnostico_id && !@diagnosticos.collect{ |i| i[1] }.member?(@prestacion_brindada.diagnostico_id) )
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Registrar el usuario que realiza la creación
    @prestacion_brindada.updater_id = current_user.id
    @prestacion_brindada.datos_reportables_asociados.each do |dra|
      dra.updater_id = current_user.id
    end

    # Verificar si hay advertencias presentes, para modificar el estado de la prestación
    if @prestacion_brindada.hay_advertencias?
      if !@prestacion_brindada.datos_reportables_incompletos
        @prestacion_brindada.estado_de_la_prestacion_id = EstadoDeLaPrestacion.id_del_codigo("F")
      end
    else
      @prestacion_brindada.estado_de_la_prestacion_id = EstadoDeLaPrestacion.id_del_codigo("R")
    end

    # Guardar la prestación y los datos reportables asociados
    @prestacion_brindada.save

    if @prestacion_brindada.hay_advertencias?
      redirect_to(@prestacion_brindada,
        :flash => { :tipo => :advertencia,
          :titulo => 'Los datos de la prestación brindada se modificaron, pero hay advertencias',
          :mensaje => 'Intente corregir los problemas detectados para reducir los rechazos en la facturación.' }
      )
    else
      redirect_to(@prestacion_brindada,
        :flash => { :tipo => :ok, :titulo => 'Los datos de la prestación brindada se modificaron correctamente' }
      )
    end
  end

  # DELETE /novedades_de_los_afiliados/:id
  def destroy
    # Verificar los permisos del usuario
    if cannot? :update, PrestacionBrindada
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Buscar la prestación
    @prestacion_brindada = PrestacionBrindada.find(params[:id])

    # Verificar que la prestación brindada esté pendiente
    if !@prestacion_brindada.pendiente?
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Cambiar el estado de la prestación por el que corresponde a la anulación por el usuario
    @prestacion_brindada.estado_de_la_prestacion_id = EstadoDeLaPrestacion.id_del_codigo("U")
    @prestacion_brindada.save(:validate => false)

    redirect_to( prestacion_brindada_path(@prestacion_brindada),
      :flash => { :tipo => :advertencia, :titulo => "El registro de la prestación brindada fue anulado",
        :mensaje => "Esta prestación no podrá ser modificada ni facturada."
      }
    )
 end

end
