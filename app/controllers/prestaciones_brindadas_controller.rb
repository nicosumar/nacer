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
    end

  end

  # GET /prestacion_brindada/:id
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

    # Obtener la adenda solicitada
    begin
      @prestacion_brindada =
        PrestacionBrindada.find( params[:id],
          :include => [:estado_de_la_prestacion]
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
      NovedadDelAfiliado.where(:clave_de_beneficiario => @prestacion_brindada.clave_de_beneficiario,
        :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:pendiente => true)).first
    if not @beneficiario
      @beneficiario = Afiliado.find_by_clave_de_beneficiario(@prestacion_brindada.clave_de_beneficiario)
    end

  end

  # GET /addendas/new
  def new
    # Verificar los permisos del usuario
    if cannot? :create, Addenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Para crear addendas, debe accederse desde la página del convenio que se modificará
    if !params[:convenio_de_gestion_id]
      redirect_to( convenios_de_gestion_url,
        :flash => { :tipo => :advertencia, :titulo => "No se ha seleccionado un convenio de gestión",
          :mensaje => [ "Para poder crear la nueva adenda, debe hacerlo accediendo antes a la página " +
            "del convenio de gestión que va a modificarse.",
            "Seleccione el convenio de gestión del listado, o realice una búsqueda para encontrarlo."
          ]
        }
      )
      return
    end

    # Obtener el convenio de gestión asociado
    begin
      @convenio_de_gestion = ConvenioDeGestion.find(params[:convenio_de_gestion_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to(
        root_url,
        :flash => {:tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Crear los objetos necesarios para la vista
    @addenda = Addenda.new
    @prestaciones_alta = Prestacion.no_autorizadas(@convenio_de_gestion.efector.id).collect{
      |p| [p.codigo + " - " + p.nombre_corto, p.id]
    }
    @prestaciones_baja = PrestacionAutorizada.autorizadas(@convenio_de_gestion.efector.id).collect{
      |p| [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id]
    }
    @prestacion_autorizada_alta_ids = []
    @prestacion_autorizada_baja_ids = []
  end

  # GET /addendas/:id/edit
  def edit
    # Verificar los permisos del usuario
    if cannot? :update, Addenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener la adenda
    begin
      @addenda = Addenda.find( params[:id],
        :include => [
          {:convenio_de_gestion => :efector},
          {:prestaciones_autorizadas_alta => :prestacion},
          {:prestaciones_autorizadas_baja => :prestacion}
        ]
      )
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Crear los objetos necesarios para la vista
    @convenio_de_gestion = @addenda.convenio_de_gestion
    @prestaciones_alta = Prestacion.no_autorizadas_antes_del_dia(
      @convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).collect{
        |p| [p.codigo + " - " + p.nombre_corto, p.id]
      }
    @prestaciones_baja = PrestacionAutorizada.autorizadas_antes_del_dia(
      @convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).collect{
        |p| [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id]
      }
    @prestacion_autorizada_alta_ids =
      @addenda.prestaciones_autorizadas_alta.collect{
        |p| p.prestacion_id
      }
    @prestacion_autorizada_baja_ids =
      @addenda.prestaciones_autorizadas_baja.collect{
        |p| p.id
      }
  end

  # POST /addendas
  def create
    # Verificar los permisos del usuario
    if cannot? :create, Addenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar si la petición contiene los parámetros esperados
    if !params[:addenda] || !params[:addenda][:convenio_de_gestion_id]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Obtener el convenio de gestión asociado
    begin
      @convenio_de_gestion = ConvenioDeGestion.find(params[:addenda][:convenio_de_gestion_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Guardar las prestaciones seleccionadas para dar de alta y de baja
    @prestacion_autorizada_alta_ids = params[:addenda].delete(:prestacion_autorizada_alta_ids).reject(&:blank?) || []
    @prestacion_autorizada_baja_ids = params[:addenda].delete(:prestacion_autorizada_baja_ids).reject(&:blank?) || []

    # Crear una nueva adenda desde los parámetros
    @addenda = Addenda.new(params[:addenda])

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @prestaciones_alta =
      Prestacion.no_autorizadas(@convenio_de_gestion.efector.id).collect{
        |p| [p.codigo + " - " + p.nombre_corto, p.id]
      }
    @prestaciones_baja =
      PrestacionAutorizada.autorizadas(@convenio_de_gestion.efector.id).collect{
        |p| [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id]
      }

    # Verificar la validez del objeto
    if @addenda.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if ( @prestacion_autorizada_alta_ids.any?{|p_id| !((@prestaciones_alta.collect{|p| p[1]}).member?(p_id.to_i))} ||
           @prestacion_autorizada_baja_ids.any?{|p_id| !((@prestaciones_baja.collect{|p| p[1]}).member?(p_id.to_i))} )
        redirect_to( root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre el incidente."
          }
        )
        return
      end

      # Registrar el usuario que realiza la creación
      @addenda.creator_id = current_user.id
      @addenda.updater_id = current_user.id

      # Guardar la nueva addenda y sus prestaciones asociadas
      if @addenda.save
        @prestacion_autorizada_alta_ids.each do |prestacion_id|
          prestacion_autorizada_alta = PrestacionAutorizada.new
          prestacion_autorizada_alta.attributes = {
            :efector_id => @convenio_de_gestion.efector_id,
            :prestacion_id => prestacion_id,
            :fecha_de_inicio => @addenda.fecha_de_inicio
          }
          @addenda.prestaciones_autorizadas_alta << prestacion_autorizada_alta
        end
        @prestacion_autorizada_baja_ids.each do |prestacion_autorizada_id|
          prestacion_autorizada_baja = PrestacionAutorizada.find(prestacion_autorizada_id)
          prestacion_autorizada_baja.attributes = {
            :fecha_de_finalizacion => @addenda.fecha_de_inicio
          }
          @addenda.prestaciones_autorizadas_baja << prestacion_autorizada_baja
        end
      end

      # Redirigir a la nueva adenda creada
      redirect_to(@addenda,
        :flash => { :tipo => :ok, :titulo => 'La adenda se creó correctamente.' }
      )
    else
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "new"
    end
  end

  # PUT /addendas/:id
  def update
    # Verificar los permisos del usuario
    if cannot? :update, Addenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar si la petición contiene los parámetros esperados
    if !params[:addenda]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Obtener la addenda que se actualizará y su convenio de gestión
    begin
      @addenda = Addenda.find(params[:id], :include => [{:convenio_de_gestion => :efector},
        {:prestaciones_autorizadas_alta => :prestacion}, {:prestaciones_autorizadas_baja => :prestacion}])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end
    @convenio_de_gestion = @addenda.convenio_de_gestion

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @prestaciones_alta = Prestacion.no_autorizadas_antes_del_dia(
      @convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).collect{
        |p| [p.codigo + " - " + p.nombre_corto, p.id]
      }
    @prestaciones_baja = PrestacionAutorizada.autorizadas_antes_del_dia(
      @convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).collect{
        |p| [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id]
      }

    # Preservar las prestaciones seleccionadas para dar de alta y de baja
    @prestacion_autorizada_alta_ids = params[:addenda].delete(:prestacion_autorizada_alta_ids).reject(&:blank?) || []
    @prestacion_autorizada_baja_ids = params[:addenda].delete(:prestacion_autorizada_baja_ids).reject(&:blank?) || []

    # Actualizar los valores de los atributos no protegidos por asignación masiva
    @addenda.attributes = params[:addenda]

    # Verificar la validez del objeto
    if @addenda.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if ( @prestacion_autorizada_alta_ids.any?{|p_id| !((@prestaciones_alta.collect{|p| p[1]}).member?(p_id.to_i))} ||
           @prestacion_autorizada_baja_ids.any?{|p_id| !((@prestaciones_baja.collect{|p| p[1]}).member?(p_id.to_i))} )
        redirect_to( root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre el incidente."
          }
        )
        return
      end

      # Registrar el usuario que realiza la modificación
      @addenda.updater_id = current_user.id

      # Guardar la nueva addenda y sus prestaciones asociadas
      if @addenda.save
        # Modificar los registros dependientes en la tabla asociada si los parámetros pasaron todas las validaciones
        # TODO: cambiar este método ya que destruye previamente la información existente
        @addenda.prestaciones_autorizadas_alta.destroy_all
        @prestacion_autorizada_alta_ids.each do |prestacion_id|
          prestacion_autorizada_alta = PrestacionAutorizada.new
          prestacion_autorizada_alta.attributes = 
            {
              :efector_id => @convenio_de_gestion.efector_id,
              :prestacion_id => prestacion_id,
              :fecha_de_inicio => @addenda.fecha_de_inicio
            }
         @addenda.prestaciones_autorizadas_alta << prestacion_autorizada_alta
        end
        @addenda.prestaciones_autorizadas_baja.each do |p|
          prestacion_autorizada = PrestacionAutorizada.find(p)
          prestacion_autorizada.attributes = 
            {
              :fecha_de_finalizacion => nil,
              :autorizante_de_la_baja_type => nil,
              :autorizante_de_la_baja_id => nil
            }
          prestacion_autorizada.save
        end
        @prestacion_autorizada_baja_ids.each do |prestacion_autorizada_id|
         prestacion_autorizada_baja = PrestacionAutorizada.find(prestacion_autorizada_id)
          prestacion_autorizada_baja.attributes = {:fecha_de_finalizacion => @addenda.fecha_de_inicio}
          @addenda.prestaciones_autorizadas_baja << prestacion_autorizada_baja
        end
      end

      # Redirigir a la adenda modificada
      redirect_to(@addenda,
        :flash => { :tipo => :ok, :titulo => 'Las modificaciones a la adenda se guardaron correctamente.' }
      )
    else
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "edit"
    end
  end

end
