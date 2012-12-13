# -*- encoding : utf-8 -*-
class ConveniosDeGestionController < ApplicationController
  before_filter :authenticate_user!

  # GET /convenios_de_gestion
  def index
    # Verificar los permisos del usuario
    if cannot? :read, ConvenioDeGestion
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el listado de convenios
    @convenios_de_gestion =
      ConvenioDeGestion.paginate(
        :page => params[:page], :per_page => 20, :include => :efector, :order => "updated_at DESC"
      )
  end

  # GET /convenios_de_gestion/:id
  def show
    # Verificar los permisos del usuario
    if cannot? :read, ConvenioDeGestion
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el convenio
    begin
      @convenio_de_gestion =
        ConvenioDeGestion.find(params[:id],
          :include => [
            :efector, {:prestaciones_autorizadas => :prestacion},
            { :addendas => [ {:prestaciones_autorizadas_alta => :prestacion}, {:prestaciones_autorizadas_baja => :prestacion} ] }
          ]
        )
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
  end

  # GET /convenios_de_gestion/new
  def new
    # Verificar los permisos del usuario
    if cannot? :create, ConvenioDeGestion
      redirect_to(root_url,
        :flash => {:tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear los objetos necesarios para la vista
    @convenio_de_gestion = ConvenioDeGestion.new
    @efectores = Efector.que_no_tengan_convenio.collect{ |e| [e.nombre_corto, e.id] }
    @efector_id = nil
    @prestaciones = Prestacion.find(:all, :order => :codigo).collect{ |p| [p.codigo + " - " + p.nombre_corto, p.id] }
    @prestacion_autorizada_ids = []
  end

  # GET /convenios_de_gestion/:id/edit
  def edit
    # Verificar los permisos del usuario
    if cannot? :update, ConvenioDeGestion
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el convenio
    begin
      @convenio_de_gestion = ConvenioDeGestion.find(params[:id], :include => [:efector, :prestaciones_autorizadas, :addendas])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear los objetos necesarios para generar la vista
    @prestaciones = Prestacion.find(:all, :order => :codigo).collect{ |p| [p.codigo + " - " + p.nombre_corto, p.id] }
    @prestacion_autorizada_ids = @convenio_de_gestion.prestaciones_autorizadas.collect{ |p| p.prestacion_id }
  end

  # POST /convenios_de_gestion
  def create
    # Verificar los permisos del usuario
    if cannot? :create, ConvenioDeGestion
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que la petición contenga los parámetros esperados
    if !params[:convenio_de_gestion]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Guardar las prestaciones seleccionadas para luego rellenar la tabla asociada si se graba correctamente
    @prestacion_autorizada_ids = params[:convenio_de_gestion].delete(:prestacion_autorizada_ids) || []

    # Crear un nuevo convenio desde los parámetros
    @convenio_de_gestion = ConvenioDeGestion.new(params[:convenio_de_gestion])

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @efectores = Efector.que_no_tengan_convenio.collect{ |e| [e.nombre_corto, e.id] }
    @efector_id = @convenio_de_gestion.efector_id
    @prestaciones = Prestacion.find(:all, :order => :codigo).collect{ |p| [p.codigo + " - " + p.nombre_corto, p.id] }

    # Verificar la validez del objeto
    if @convenio_de_gestion.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if ( !@efectores.collect{ |i| i[1] }.member?(@efector_id) ||
           @prestacion_autorizada_ids.any?{|p_id| !((@prestaciones.collect{|p| p[1]}).member?(p_id.to_i))} )
        redirect_to(root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre este incidente."
          }
        )
        return
      end

      # Registrar el usuario que realiza la creación
      @convenio_de_gestion.creator_id = current_user.id
      @convenio_de_gestion.updater_id = current_user.id

      # Crear las prestaciones autorizadas
      if @prestacion_autorizada_ids
        @convenio_de_gestion.prestaciones_autorizadas.build(
          @prestacion_autorizada_ids.collect{
            |p| {
              :efector_id => @convenio_de_gestion.efector.id, :prestacion_id => p,
              :fecha_de_inicio => @convenio_de_gestion.fecha_de_inicio
            }
          }
        )
      end

      # Guardar el nuevo convenio
      @convenio_de_gestion.save
      redirect_to(@convenio_de_gestion,
        :flash => { :tipo => :ok, :titulo => 'El convenio de gestión se creó correctamente.' }
      )
    else
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "new"
    end
  end

  # PUT /convenios_de_gestion/:id
  def update
    # Verificar los permisos del usuario
    if cannot? :update, ConvenioDeGestion
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que la petición contenga los parámetros esperados
    if !params[:convenio_de_gestion]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Guardar las prestaciones seleccionadas para luego rellenar la tabla asociada si se graba correctamente
    @prestacion_autorizada_ids = params[:convenio_de_gestion].delete(:prestacion_autorizada_ids) || []

    # Obtener el convenio
    begin
      @convenio_de_gestion = ConvenioDeGestion.find(params[:id], :include => [:efector, :prestaciones_autorizadas])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Actualizar los valores de los atributos para validar el registro antes de guardarlo
    @convenio_de_gestion.attributes = params[:convenio_de_gestion]

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @prestaciones = Prestacion.find(:all, :order => :codigo).collect{ |p| [p.codigo + " - " + p.nombre_corto, p.id] }

    # Verificar la validez del objeto
    if @convenio_de_gestion.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if ( @prestacion_autorizada_ids.any?{|p_id| !((@prestaciones.collect{|p| p[1]}).member?(p_id.to_i))} )
        redirect_to(root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre este incidente."
          }
        )
        return
      end

      # Registrar el usuario que realiza la modificación
      @convenio_de_gestion.updater_id = current_user.id

      # Modificar los registros dependientes
      @convenio_de_gestion.prestaciones_autorizadas.destroy_all
      @convenio_de_gestion.prestaciones_autorizadas.build(
        @prestacion_autorizada_ids.collect{
          |p| { :efector_id => @convenio_de_gestion.efector.id, :prestacion_id => p,
            :fecha_de_inicio => @convenio_de_gestion.fecha_de_inicio
          }
        }
      )

      # Guardar el convenio
      @convenio_de_gestion.save
      redirect_to(@convenio_de_gestion,
        :flash => {:tipo => :ok, :titulo => 'Las modificaciones al convenio de gestión se guardaron correctamente.' }
      )
    else
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "edit"
    end
  end

  # GET /convenios_de_gestion/:id/addendas
  def addendas
    # Verificar los permisos del usuario
    if cannot? :read, Addenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el convenio de gestión
    begin
      @convenio_de_gestion =
        ConvenioDeGestion.find(params[:id],
          :include => {
            :addendas => [ {:prestaciones_autorizadas_alta => :prestacion}, {:prestaciones_autorizadas_baja => :prestacion} ]
          }
        )
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
  end
end
