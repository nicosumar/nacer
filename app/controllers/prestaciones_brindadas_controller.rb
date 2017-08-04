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

    # Verificar si se solicitó el historial de un beneficiario en particular o todas las prestaciones
    # registradas en esta UAD
    if params[:clave_de_beneficiario].present?
      @beneficiario =
        NovedadDelAfiliado.where(
          :clave_de_beneficiario => params[:clave_de_beneficiario],
          :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P"]),
          :tipo_de_novedad_id => TipoDeNovedad.id_del_codigo("M")
        ).order("updated_at DESC").first
      if not @beneficiario.present?
        @beneficiario = Afiliado.find_by_clave_de_beneficiario(params[:clave_de_beneficiario])
      end
      if not @beneficiario.present?
        @beneficiario =
          NovedadDelAfiliado.where(
            :clave_de_beneficiario => params[:clave_de_beneficiario],
            :tipo_de_novedad_id => TipoDeNovedad.id_del_codigo("A")
          ).order("updated_at DESC").first
      end

      if not @beneficiario.present?
        redirect_to(
          root_url,
          :flash => {:tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre el incidente."
          }
        )
        return
      end

      # Obtener las prestaciones filtradas para esta clave de beneficiario
      @prestaciones_brindadas =
        PrestacionBrindada.del_beneficiario(@beneficiario.clave_de_beneficiario).paginate(:page => params[:page], :per_page => 20,
          :include => [:prestacion, :diagnostico], :order => "fecha_de_la_prestacion DESC"
        )
    else
      # Preparar los objetos necesarios para la vista
      @estados_de_las_prestaciones =
        [["En cualquier estado", nil]] +
        EstadoDeLaPrestacion.find(:all, :order => :id).collect{ |e| ["En estado '" + e.nombre + "'", e.id] }

      # Verificar si hay un parámetro para filtrar las novedades
      if params[:estado_de_la_prestacion_id].blank?
        # No hay filtro, devolver todas las prestaciones brindadas
        @prestaciones_brindadas =
          PrestacionBrindada.paginate( :page => params[:page], :per_page => 20, :include => [:prestacion, :diagnostico, :creator, :efector],
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

        # Obtener las prestaciones filtradas de acuerdo con el parámetro
        if @estado_de_la_prestacion_id == 3 # Registradas, más todas las que tienen advertencias pero no son visibles
          @prestaciones_brindadas =
            PrestacionBrindada.sin_advertencias.paginate(:page => params[:page], :per_page => 20,
              :include => [:prestacion, :diagnostico], :order => "prestaciones_brindadas.updated_at DESC"
            )
        elsif @estado_de_la_prestacion_id == 2 # Con advertencias, pero sólo si son visibles
          @prestaciones_brindadas =
            PrestacionBrindada.con_advertencias_visibles.paginate(:page => params[:page], :per_page => 20,
              :include => [:prestacion, :diagnostico], :order => "prestaciones_brindadas.updated_at DESC"
            )
        # Para las prestaciones vencidas, devolver las brindadas cuyo estado de brindada sea 11 y de liquidacion 13 (vencidas)
        elsif @estado_de_la_prestacion_id == 13
          @prestaciones_brindadas = 
            PrestacionBrindada.vencidas.paginate(:page => params[:page], :per_page => 20,
              :include => [:prestacion, :diagnostico], :order => "prestaciones_brindadas.updated_at DESC"
            )
        else
          @prestaciones_brindadas =
            PrestacionBrindada.con_estado(@estado_de_la_prestacion_id).paginate(:page => params[:page], :per_page => 20,
              :include => [:prestacion, :diagnostico], :order => "prestaciones_brindadas.updated_at DESC"
            )
        end
      end
    end

    # Si la UAD centraliza datos de más de un efector, mostrar la columna 'Efector' en la vista
    @mostrar_efector = (UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual]).efectores.size > 1)
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
            :estado_de_la_prestacion, {:prestacion => :unidad_de_medida}, :efector, :diagnostico, :datos_reportables_asociados,
            :metodos_de_validacion_fallados
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
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P"]),
        :tipo_de_novedad_id => TipoDeNovedad.id_del_codigo("M")
      ).order("updated_at DESC").first
    if not @beneficiario.present?
      @beneficiario = Afiliado.find_by_clave_de_beneficiario(@prestacion_brindada.clave_de_beneficiario)
    end
    if not @beneficiario.present?
      @beneficiario =
        NovedadDelAfiliado.where(
          :clave_de_beneficiario => @prestacion_brindada.clave_de_beneficiario,
          :tipo_de_novedad_id => TipoDeNovedad.id_del_codigo("A")
        ).order("updated_at DESC").first
    end

    # Obtener asistentes
    @asistentes = AsistenteTaller.where(
        :prestacion_brindada_id => @prestacion_brindada.id,
        :efector_id => @prestacion_brindada.efector_id
      )
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
    if !params[:clave_de_beneficiario] && !params[:prestacion_brindada] && !params[:terminos] && !params[:comunitaria]
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

    if !params[:comunitaria]
      # Obtener la novedad o el afiliado asociado a la clave
      @beneficiario =
        NovedadDelAfiliado.where(
          :clave_de_beneficiario => (
              params[:clave_de_beneficiario] ||
              params[:prestacion_brindada][:clave_de_beneficiario]
            ),
          :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P"]),
          :tipo_de_novedad_id => TipoDeNovedad.find_by_codigo("M")
        ).first
      if not @beneficiario.present?
        @beneficiario =
          Afiliado.find_by_clave_de_beneficiario(
            params[:clave_de_beneficiario] || params[:prestacion_brindada][:clave_de_beneficiario]
          )
      end
      if not @beneficiario.present?
        @beneficiario =
          NovedadDelAfiliado.where(
            :clave_de_beneficiario => (
              params[:clave_de_beneficiario] ||
              params[:prestacion_brindada][:clave_de_beneficiario]
            ),
            :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["I", "R", "P", "Z", "U", "S"]),
            :tipo_de_novedad_id => TipoDeNovedad.find_by_codigo("A")
          ).first
      end

      if not @beneficiario.present?
        redirect_to(
          root_url,
          :flash => {:tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre el incidente."
          }
        )
        return
      end

      if @beneficiario.is_a?(NovedadDelAfiliado) && ["I", "Z", "U", "S"].member?(@beneficiario.estado_de_la_novedad.codigo)
        redirect_to(
          root_url,
          :flash => {:tipo => :error, :titulo => "Empadronamiento incorrecto o inválido",
            :mensaje => "No se pueden registrar prestaciones a beneficiarios que poseen una inscripción rechazada, anulada, o con datos obligatorios incompletos. Verifique y corrija la situación de registro del beneficiario o de la beneficiaria en el padrón antes de intentar registrar la prestación."
          }
        )
        return
      elsif @beneficiario.is_a?(Afiliado)
        novedad = NovedadDelAfiliado.new
        novedad.copiar_atributos_del_afiliado(@beneficiario)
        novedad.generar_advertencias
        if novedad.advertencias.size > 0
          redirect_to(
            root_url,
            :flash => {:tipo => :error, :titulo => "Empadronamiento incorrecto o inválido",
              :mensaje => "No se pueden registrar prestaciones a beneficiarios que poseen una inscripción rechazada, anulada, o con datos obligatorios incompletos. Verifique y corrija la situación de registro del beneficiario o de la beneficiaria en el padrón antes de intentar registrar la prestación."
            }
          )
          return
        end
      end
    end

    # Esta acción se ejecuta en dos partes. La inicial fija el efector y la fecha de la prestación, y la segunda define el resto
    # de los datos.
    if !params[:commit]
      # Preparar los objetos para la vista de la primer etapa (selección de efector y fecha)
      @prestacion_brindada = PrestacionBrindada.new
      if !params[:comunitaria]
        @prestacion_brindada.clave_de_beneficiario = @beneficiario.clave_de_beneficiario
      end
      @efectores = UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual]).efectores.order(:nombre).collect{
        |e| [e.cuie + " - " + e.nombre, e.id]
      }

      # Obtener el último registro cargado por este usuario en esta misma sesión, para prestablecer los valores de efector y fecha
      ultimo_registro =
        PrestacionBrindada.where(
          "creator_id = ? AND created_at > ?",
          current_user.id,
          current_user.current_sign_in_at
        ).order("created_at DESC").limit(1)

      if @efectores.size == 1
        # Fijar el efector si la UAD solo tiene asociado un efector para facturación
        @prestacion_brindada.efector_id = @efectores.first[1]
      else
        @prestacion_brindada.efector_id = (ultimo_registro.first ? ultimo_registro.first.efector_id : nil)
      end
      @prestacion_brindada.fecha_de_la_prestacion = (ultimo_registro.first ? ultimo_registro.first.fecha_de_la_prestacion : nil)

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
        render :action => "efector_y_fecha"
        return
      end
    end

    # Generar el listado de prestaciones válidas
    # autorizadas_por_efector =
    #   Prestacion.find(
    #     @prestacion_brindada.efector.prestaciones_autorizadas_al_dia(@prestacion_brindada.fecha_de_la_prestacion).collect{
    #       |p| p.prestacion_id
    #     }
    #   )
    # if !params[:comunitaria]
    #   autorizadas_por_grupo =
    #     @beneficiario.grupo_poblacional_al_dia(@prestacion_brindada.fecha_de_la_prestacion).prestaciones_autorizadas
    #   autorizadas_por_sexo = @beneficiario.sexo.prestaciones_autorizadas
    #   @prestaciones =
    #     autorizadas_por_efector.keep_if{
    #         |p| autorizadas_por_sexo.member?(p) && autorizadas_por_grupo.member?(p)
    #       }.collect{ |p| [p.nombre_corto + " - " + p.codigo, p.id] }.sort
    # else
    #   @prestaciones = autorizadas_por_efector.keep_if{|p| p.comunitaria}.collect{ |p| [p.nombre_corto + " - " + p.codigo, p.id] }.sort
    # end

    # @diagnosticos = []

   
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

    # Verificar que la prestación esté en un estado modificable
    if !@prestacion_brindada.pendiente?
      redirect_to(
        root_url,
        :flash => {:tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    if !@prestacion_brindada.prestacion.comunitaria
      # Obtener el afiliado o la novedad asociadas a la prestación
      @beneficiario =
        NovedadDelAfiliado.where(
          :clave_de_beneficiario => @prestacion_brindada.clave_de_beneficiario,
          :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P"]),
          :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
        ).first

      if !@beneficiario.present?
        @beneficiario = Afiliado.find_by_clave_de_beneficiario(@prestacion_brindada.clave_de_beneficiario)
      end

      if !@beneficiario.present?
        redirect_to(
          root_url,
          :flash => {:tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre el incidente."
          }
        )
        return
      end

    end

    # Generar el listado de diagnósticos válidos para la prestación
    @diagnosticos = @prestacion_brindada.prestacion.diagnosticos.collect{|d| [d.nombre_y_codigo, d.id]}.sort

    # Obtener asistentes
    @asistentes = AsistenteTaller.where(
        :prestacion_brindada_id => @prestacion_brindada.id,
        :efector_id => @prestacion_brindada.efector_id
      )
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

    if !params[:prestacion_brindada][:clave_de_beneficiario].blank?
      # Obtener la novedad o el afiliado asociado a la clave
      @beneficiario =
        NovedadDelAfiliado.where(
          :clave_de_beneficiario => params[:prestacion_brindada][:clave_de_beneficiario],
          :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P"]),
          :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
        ).first

      if !@beneficiario.present?
        @beneficiario =
          Afiliado.find_by_clave_de_beneficiario(
            params[:prestacion_brindada][:clave_de_beneficiario]
          )
      end

      if !@beneficiario.present?
        redirect_to(
          root_url,
          :flash => {:tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre el incidente."
          }
        )
        return
      end
    end

    # Crear el objeto desde los parámetros y verificar si está correcto
    @prestacion_brindada = PrestacionBrindada.new(params[:prestacion_brindada])

    # Marcar la prestación brindada como incompleta, hasta tanto se completen las validaciones.
    @prestacion_brindada.estado_de_la_prestacion_id = EstadoDeLaPrestacion.id_del_codigo("I")

    # Generar el listado de prestaciones válidas
    autorizadas_por_efector =
      Prestacion.find(
        @prestacion_brindada.efector.prestaciones_autorizadas_al_dia(@prestacion_brindada.fecha_de_la_prestacion).collect{
          |p| p.prestacion_id
        }
      )
    if !params[:comunitaria]
      autorizadas_por_grupo =
        @beneficiario.grupo_poblacional_al_dia(@prestacion_brindada.fecha_de_la_prestacion).prestaciones_autorizadas
      autorizadas_por_sexo = @beneficiario.sexo.prestaciones_autorizadas
      @prestaciones =
        autorizadas_por_efector.keep_if{
            |p| autorizadas_por_sexo.member?(p) && autorizadas_por_grupo.member?(p)
          }.collect{ |p| [p.nombre_corto + " - " + p.codigo, p.id] }.sort
    else
      @prestaciones = autorizadas_por_efector.keep_if{|p| p.comunitaria}.collect{ |p| [p.nombre_corto + " - " + p.codigo, p.id] }.sort
    end

    if @prestacion_brindada.prestacion
      @diagnosticos = @prestacion_brindada.prestacion.diagnosticos.collect{|d| [d.nombre_y_codigo, d.id]}.sort
    else
      @diagnosticos = []
    end

    # Si la prestacion es comunitaria y se ingresaron datos de los asistentes
    if params[:comunitaria]
      nombre = params[:nombre]
      apellido = params[:apellido]
      #clase_de_documento_id = params[:clase_de_documento_id]
      tipo_de_documento_id = params[:tipo_de_documento_id]
      numero_de_documento = params[:numero_de_documento]
      sexo_id = params[:sexo_id]
      fecha_de_nacimiento = params[:fecha_de_nacimiento]
      if !nombre.blank? && 
          !apellido.blank? && 
          !numero_de_documento.blank? &&
          #!clase_de_documento_id.blank? &&
          !tipo_de_documento_id.blank? &&
          !sexo_id.blank? &&
          !fecha_de_nacimiento.blank?
        @asistentes = Array.new
        for i in 0 ... nombre.size
          @asistente = AsistenteTaller.new
          @asistente.efector = @prestacion_brindada.efector
          @asistente.prestacion_brindada = @prestacion_brindada
          @asistente.nombre = nombre[i]
          @asistente.apellido = apellido[i]
          @asistente.clase_de_documento_id = 1 #clase_de_documento_id[i] TODOS LOS ASISTENTES DEBEN TENER DOCUMENTO PROPIO
          @asistente.tipo_de_documento_id = tipo_de_documento_id[i]
          @asistente.numero_de_documento = numero_de_documento[i]
          @asistente.sexo_id = sexo_id[i]
          @asistente.fecha_de_nacimiento = fecha_de_nacimiento[i]
          @asistentes.push(@asistente)
        end
      end
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

    # Actualizar la información sobre métodos de validación que generan advertencias fallados y ajustar el estado de la prestación
    @prestacion_brindada.actualizar_metodos_de_validacion_fallados
    if @prestacion_brindada.metodos_de_validacion.size > 0
      @prestacion_brindada.estado_de_la_prestacion_id = EstadoDeLaPrestacion.id_del_codigo("F")
    else
      @prestacion_brindada.estado_de_la_prestacion_id = EstadoDeLaPrestacion.id_del_codigo("R")
    end

    # Guardar la prestación y los datos reportables asociados
    @prestacion_brindada.save

    # Guardar los datos de los asistentes en caso de ser prestacion comunitaria
    #if params[:comunitaria] && @prestacion_brindada.datos_reportables_asociados
    #  @prestacion_brindada.datos_reportables_asociados.each do |dra|
    #    if dra.dato_reportable_requerido.dato_reportable.codigo == 'ASIST' && dra.valor_integer != 1
    #      dra.delete
    #    end
    #  end
    #end
    if @asistentes
      for i in 0 ... @asistentes.size
        @asistentes[i].save
      end
    end

    # Verificar si la prestación guardada es una prestación que puede modificar el lugar de atención habitual del beneficiario
    # Las prestaciones que pueden modificar el lugar de atención no son comunitarias por lo cual debe existir el beneficiario
    if @prestacion_brindada.prestacion.modifica_lugar_de_atencion && @beneficiario.lugar_de_atencion_habitual_id != @prestacion_brindada.efector_id
      # Verificar el historial de prestaciones de este beneficiario. Si en el último año no registra prestaciones de este mismo tipo
      # que hayan sido brindadas por el efector de atención habitual, se genera automáticamente una modificación de datos que cambia
      # el lugar de atención habitual por este efector que brindó la prestación.
      if VistaGlobalDePrestacionBrindada.where("
          clave_de_beneficiario = '#{@beneficiario.clave_de_beneficiario}'
          AND fecha_de_la_prestacion > '#{(@prestacion_brindada.fecha_de_la_prestacion - 1.year).strftime("%Y-%m-%d")}'
          AND prestacion_id IN (SELECT id FROM prestaciones WHERE modifica_lugar_de_atencion)
          AND efector_id = '#{(@beneficiario.lugar_de_atencion_habitual_id.present? ? @beneficiario.lugar_de_atencion_habitual_id : 0)}'
          AND estado_de_la_prestacion_id NOT IN (SELECT id FROM estados_de_las_prestaciones WHERE codigo IN ('U', 'S'))
        ").size == 0 then
        # La variable @beneficiario puede ser una novedad ingresada para este beneficiario, o bien un registro del padrón
        if @beneficiario.is_a? Afiliado
          # Si es un registro del padrón, creamos una nueva novedad (solicitud de modificación de datos)
          novedad = NovedadDelAfiliado.new
          novedad.copiar_atributos_del_afiliado(@beneficiario)
          novedad.tipo_de_novedad_id = TipoDeNovedad.id_del_codigo("M")
          novedad.categoria_de_afiliado_id = novedad.categorizar
          novedad.apellido = novedad.apellido.mb_chars.upcase.to_s
          novedad.nombre = novedad.nombre.mb_chars.upcase.to_s
          novedad.generar_advertencias
          novedad.creator_id = current_user.id
          novedad.updater_id = current_user.id
          if novedad.advertencias && novedad.advertencias.size > 0
            novedad.estado_de_la_novedad_id = EstadoDeLaNovedad.id_del_codigo("I")
          else
            novedad.estado_de_la_novedad_id = EstadoDeLaNovedad.id_del_codigo("R")
          end
          novedad.lugar_de_atencion_habitual_id = @prestacion_brindada.efector_id
          novedad.fecha_de_la_novedad = @prestacion_brindada.fecha_de_la_prestacion
          # TODO: HARDCODED, debería ser un CI asociado a la UAD del usuario, pero quizás no es mala idea que sea el de
          # procedimientos internos
          novedad.centro_de_inscripcion_id = 316
          puts novedad.inspect
          novedad.save
        else
          # Si era una novedad pendiente, modificamos el campo lugar_de_atencion_habitual_id
          @beneficiario.update_attributes({:lugar_de_atencion_habitual_id => @prestacion_brindada.efector_id})
        end
      end
    end

    if @prestacion_brindada.metodos_de_validacion.any?{|mv| mv.visible}
      redirect_to(@prestacion_brindada,
        :flash => { :tipo => :advertencia,
          :titulo => 'La prestación brindada se registró con advertencias',
          :mensaje => 'Intente corregir los problemas detectados para reducir los rechazos en la facturación.' }
      )
    else
      if params[:comunitaria]
        redirect_to(@prestacion_brindada,
          :flash => { :tipo => :ok, :titulo => "La prestación brindada se registró correctamente. \nRECUERDE: adjuntar la planilla firmada y dejar una copia en el efector." }
        )
      else
        redirect_to(@prestacion_brindada,
          :flash => { :tipo => :ok, :titulo => 'La prestación brindada se registró correctamente' }
        )
      end
    end
  end

  # PUT /prestaciones_brindadas/:id
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

    # Verificar que la prestación esté en un estado modificable
    if !@prestacion_brindada.pendiente?
      redirect_to(
        root_url,
        :flash => {:tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    if !@prestacion_brindada.prestacion.comunitaria
      # Obtener la novedad o el afiliado asociado a la clave
      @beneficiario =
        NovedadDelAfiliado.where(
          :clave_de_beneficiario => params[:prestacion_brindada][:clave_de_beneficiario],
          :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P"]),
          :tipo_de_novedad_id => TipoDeNovedad.where(:codigo => ["A", "M"])
        ).first

      if !@beneficiario.present?
        @beneficiario =
          Afiliado.find_by_clave_de_beneficiario(
            params[:prestacion_brindada][:clave_de_beneficiario]
          )
      end

      if !@beneficiario.present?
        redirect_to(
          root_url,
          :flash => {:tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre el incidente."
          }
        )
        return
      end
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

    # Actualizar los atributos de la prestación
    @prestacion_brindada.attributes = params[:prestacion_brindada]

    # Generar el listado de diagnósticos válidos para esta prestación
    @diagnosticos = @prestacion_brindada.prestacion.diagnosticos.collect{|d| [d.nombre_y_codigo, d.id]}.sort

    # Si la prestacion es comunitaria y se ingresaron datos de los asistentes
    if params[:comunitaria]
      asistente_id = params[:asistente_id]
      nombre = params[:nombre]
      apellido = params[:apellido]
      tipo_de_documento_id = params[:tipo_de_documento_id]
      numero_de_documento = params[:numero_de_documento]
      sexo_id = params[:sexo_id]
      fecha_de_nacimiento = params[:fecha_de_nacimiento]
      eliminar = params[:eliminar]
      if !asistente_id.blank? &&
          !nombre.blank? && 
          !apellido.blank? && 
          !numero_de_documento.blank? &&
          !tipo_de_documento_id.blank? &&
          !sexo_id.blank? &&
          !fecha_de_nacimiento.blank? &&
          !eliminar.blank?
        for i in 0 ... asistente_id.size
          @asistente = AsistenteTaller.find(asistente_id[i])
          if eliminar[i] == 'true'
            @asistente.destroy
          else
            @asistente.nombre = nombre[i]
            @asistente.apellido = apellido[i]
            @asistente.tipo_de_documento_id = tipo_de_documento_id[i]
            @asistente.numero_de_documento = numero_de_documento[i]
            @asistente.sexo_id = sexo_id[i]
            @asistente.fecha_de_nacimiento = fecha_de_nacimiento[i]
            @asistente.save
          end
        end
      end
    end

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

    # Actualizar la información sobre métodos de validación que generan advertencias fallados y ajustar el estado de la prestación
    @prestacion_brindada.actualizar_metodos_de_validacion_fallados
    if @prestacion_brindada.metodos_de_validacion.size > 0
      @prestacion_brindada.estado_de_la_prestacion_id = EstadoDeLaPrestacion.id_del_codigo("F")
    else
      @prestacion_brindada.estado_de_la_prestacion_id = EstadoDeLaPrestacion.id_del_codigo("R")
    end

    # Guardar la prestación y los datos reportables asociados
    @prestacion_brindada.save

    if @prestacion_brindada.metodos_de_validacion.size > 0
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

  # DELETE /prestaciones_brindadas/:id
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
    
    if is_liquidacion_o_cuasifactura_procesando == false

      # Verificar que la prestación brindada esté pendiente

      # Cambiar el estado de la prestación por el que corresponde a la anulación por el usuario
      @prestacion_brindada.estado_de_la_prestacion_id = EstadoDeLaPrestacion.id_del_codigo("U")
      @prestacion_brindada.save(:validate => false)

      redirect_to( prestacion_brindada_path(@prestacion_brindada),
        :flash => { :tipo => :advertencia, :titulo => "El registro de la prestación brindada fue anulado",
          :mensaje => "Esta prestación no podrá ser modificada ni facturada."
        }
      )

    else

      redirect_to(prestacion_brindada_path(@prestacion_brindada),
          :flash => {:tipo => :error, :titulo => "No se puede realizar está acción",
            :mensaje => "La prestación ya se encuentra en proceso de liquidación."
            }
        )

    end

  end

  def is_liquidacion_o_cuasifactura_procesando

    # El estado del proceso está asociado a una entidad, que en este caso es la liquidación.
    # Para saber qué liquidaciones deberia checkear tengo que tomar el efector, dado que
    # cada liquidación tiene un grupo de efectores asociado. Entonces, como ya estoy logeado 
    # con un efector (uad-actual) puedo identificar ese grupo.
    # Una vez que tengo ese grupo, puedo obtener todas las liquidaciones que han sido creadas
    # para ese grupo.
    # Finalmente, para cada una de esas liquidaciones puedo obtener el ultimo estado del proceso asociado.
    # Si está en estado PROCESANDO (id = 2) entonces no voy a dejar que se anule esta prestación.

    # Estabamos viendo con Diego que en realidad no debería permitir que se anule desde
    # el momento que comienza la liquidación.

    cond_liquidacion = false;
    cond_cuasifactura = false;
    
    id_grupo = @uad_actual.efector.grupo_de_efectores_liquidacion_id

    @liquidaciones = LiquidacionSumar.where(:grupo_de_efectores_liquidacion_id => id_grupo)

    @liquidaciones.each do |l|

      if(@prestacion_brindada.fecha_de_la_prestacion <= l.periodo.fecha_limite_prestaciones)

        todos_los_procesos = ProcesoDeSistema.where('entidad_relacionada_id = ? and tipo_proceso_de_sistema_id in (?, ?)', l.id,TiposProcesosDeSistemas::PROCESAR_LIQUIDACION_SUMAR, TiposProcesosDeSistemas::GENERAR_CUASIFACTURAS_LIQUIDACION_SUMAR).order('tipo_proceso_de_sistema_id').includes(:estado_proceso_de_sistema)

        todos_los_procesos.each do |p|

          if p.tipo_proceso_de_sistema_id == TiposProcesosDeSistemas::PROCESAR_LIQUIDACION_SUMAR

            if (p.estado_proceso_de_sistema.id == 2 || p.estado_proceso_de_sistema.id == 5) #EN PROCESO O COMPLETADA

              cond_liquidacion = true

            end

          else #TiposProcesosDeSistemas::GENERAR_CUASIFACTURAS_LIQUIDACION_SUMAR

            if (p.estado_proceso_de_sistema.id != 5) #COMPLETADA

              cond_cuasifactura = true

            end

          end

        end

      end

    end

    return !cond_cuasifactura ? cond_cuasifactura : cond_liquidacion
    
    # EN OTRAS PALABRAS...

    # if(cond_cuasifactura)

    #   return true

    # else

    #   if(cond_liquidacion)

    #     return true

    #   else

    #     return false

    #   end

    # end

  end

end
