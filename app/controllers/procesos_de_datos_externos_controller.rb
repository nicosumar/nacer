# -*- encoding : utf-8 -*-
class ProcesosDeDatosExternosController < ApplicationController
  before_filter :authenticate_user!

  # GET /procesos_de_datos_externos
  def index
    # Verificar los permisos del usuario
    if cannot? :read, ProcesoDeDatosExternos
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el listado de procesos
    @procesos = ProcesoDeDatosExternos.paginate(:page => params[:page], :per_page => 20, :order => "id DESC")
  end

  # GET /procesos_de_datos_externos/:id
  def show
    # Verificar los permisos del usuario
    if cannot? :read, ProcesoDeDatosExternos
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el proceso
    begin
      @proceso = ProcesoDeDatosExternos.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
  end

  # GET /procesos_de_datos_externos/new
  def new
    # Verificar los permisos del usuario
    if cannot? :create, ProcesoDeDatosExternos
      redirect_to(root_url,
        :flash => {:tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear los objetos necesarios para la vista
    @proceso = ProcesoDeDatosExternos.new
    @tipos_de_procesos = TipoDeProceso.all.collect {|t| [t.nombre, t.id]}
  end

  # GET /procesos_de_datos_externos/:id/edit
  def edit
    # Verificar los permisos del usuario
    if cannot? :update, ProcesoDeDatosExternos
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el proceso
    begin
      @proceso = ProcesoDeDatosExternos.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    if !@proceso.modificable?
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear los objetos necesarios para generar la vista
    @tipos_de_procesos = TipoDeProceso.all.collect {|t| [t.nombre, t.id]}
  end

  # POST /procesos_de_datos_externos
  def create
    # Verificar los permisos del usuario
    if cannot? :create, ProcesoDeDatosExternos
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que la petición contenga los parámetros esperados
    if !params[:proceso_de_datos_externos]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Crear un nuevo proceso desde los parámetros
    @proceso = ProcesoDeDatosExternos.new(params[:proceso_de_datos_externos])

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @tipos_de_procesos = TipoDeProceso.all.collect {|t| [t.nombre, t.id]}

    # Verificar la validez del objeto
    if @proceso.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if @proceso.tipo_de_proceso_id && !@tipos_de_procesos.collect{ |i| i[1] }.member?(@proceso.tipo_de_proceso_id)
        redirect_to(root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre este incidente."
          }
        )
        return
      end

      # Registrar el usuario que realiza la creación
      @proceso.creator_id = current_user.id
      @proceso.updater_id = current_user.id

      # Guardar el nuevo proceso
      @proceso.save
      redirect_to(@proceso,
        :flash => { :tipo => :ok, :titulo => 'El proceso se creó correctamente.' }
      )
    else
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "new"
    end
  end

  # PUT /procesos_de_datos_externos/:id
  def update
    # Verificar los permisos del usuario
    if cannot? :update, ProcesoDeDatosExternos
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que la petición contenga los parámetros esperados
    if !params[:proceso_de_datos_externos]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Obtener el proceso
    begin
      @proceso = ProcesoDeDatosExternos.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    if !@proceso.modificable?
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Actualizar los valores de los atributos para validar el registro antes de guardarlo
    @proceso.attributes = params[:proceso_de_datos_externos]

    # Crear los objetos necesarios para generar la vista
    @tipos_de_procesos = TipoDeProceso.all.collect {|t| [t.nombre, t.id]}

    # Verificar la validez del objeto
    if @proceso.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if @proceso.tipo_de_proceso_id && !@tipos_de_procesos.collect{ |i| i[1] }.member?(@proceso.tipo_de_proceso_id)
        redirect_to(root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre este incidente."
          }
        )
        return
      end

      # Registrar el usuario que realiza la modificación
      @proceso.updater_id = current_user.id

      # Guardar el proceso
      @proceso.save
      redirect_to(@proceso,
        :flash => {:tipo => :ok, :titulo => 'Las modificaciones al proceso se guardaron correctamente.' }
      )
    else
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "edit"
    end # if @proceso.valid?

  end # def update

  # GET /efectores/:id/prestaciones_autorizadas
  def prestaciones_autorizadas
    # Verificar los permisos del usuario
    if cannot? :read, PrestacionAutorizada
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el efector
    begin
      @efector =
        Efector.find(params[:id], :include => { :prestaciones_autorizadas => [:autorizante_al_alta, :prestacion] })
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que el efector tenga un convenio de gestión suscrito
    if !@efector.convenio_de_gestion_sumar && !@efector.convenio_de_gestion
      redirect_to(root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
  end

  # GET /efectores/:id/referentes
  def referentes
    # Verificar los permisos del usuario
    if cannot? :read, Referente
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el efector
    begin
      @efector =
        Efector.find(params[:id], :include => { :referentes => :contacto })
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear los objetos para la vista
    @referentes = @efector.referentes
  end

end
