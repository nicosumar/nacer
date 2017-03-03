# -*- encoding : utf-8 -*-
class ContactosController < ApplicationController
  before_filter :authenticate_user!

  # GET /contactos
  def index
    # Verificar los permisos del usuario
    if cannot? :read, Contacto
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el listado de contactos
    @contactos = Contacto.paginate(:page => params[:page], :per_page => 20, :order => [:apellidos, :nombres])
  end

  # GET /contactos/:id
  def show
    # Verificar los permisos del usuario
    if cannot? :read, Contacto
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el contacto solicitado
    begin
      @contacto = Contacto.find(params[:id], :include => :sexo)
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "El contacto solicitado no existe",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
  end

  # GET /contactos/new
  def new
    # Verificar los permisos del usuario
    if cannot? :create, Contacto
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear los objetos necesarios para la vista
    @contacto = Contacto.new
    @tipos_de_documentos = TipoDeDocumento.where(:activo => true).collect{ |i| [i.nombre, i.id]}
    @tipo_de_documento_id = nil
    @sexos = Sexo.find(:all).collect{ |s| [s.nombre, s.id] }
    @sexo_id = nil
  end

  # GET /contactos/:id/edit
  def edit
    # Verificar los permisos del usuario
    if cannot? :update, Contacto
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el contacto
    begin
      @contacto = Contacto.find(params[:id], :include => :sexo)
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear los objetos necesarios para la vista
    @tipos_de_documentos = TipoDeDocumento.where(:activo => true).collect{ |i| [i.nombre, i.id]}
    @tipo_de_documento_id = @contacto.tipo_de_documento_id
    @sexos = Sexo.find(:all).collect{ |s| [s.nombre, s.id] }
    @sexo_id = @contacto.sexo_id
  end

  # POST /contactos
  def create
    # Verificar los permisos del usuario
    if cannot? :create, Contacto
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que la petición contenga los parámetros esperados
    if !params[:contacto]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Crear el nuevo objeto
    @contacto = Contacto.new(params[:contacto])

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @tipos_de_documentos = TipoDeDocumento.where(:activo => true).collect{ |i| [i.nombre, i.id]}
    @tipo_de_documento_id = @contacto.tipo_de_documento_id
    @sexos = Sexo.find(:all).collect{ |s| [s.nombre, s.id] }
    @sexo_id = @contacto.sexo_id

    # Verificar la validez del objeto
    if @contacto.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if (@sexo_id && !(@sexos.collect{|s| s[1]}.member?(@sexo_id)) ||
          @tipo_de_documento_id && !(@tipos_de_documentos.collect{|s| s[1]}.member?(@tipo_de_documento_id)))
        redirect_to( root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre el incidente."
          }
        )
        return
      end

      # Registrar el usuario que realiza la creación
      @contacto.creator_id = current_user.id
      @contacto.updater_id = current_user.id

      # Guardar el nuevo convenio
      @contacto.save
      redirect_to(@contacto,
        :flash => { :tipo => :ok, :titulo => 'El contacto se creó correctamente.' }
      )
    else
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "new"
    end
  end

  # PUT /contactos/:id
  def update
    # Verificar los permisos del usuario
    if cannot? :update, Contacto
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que la petición contenga los parámetros esperados
    if !params[:contacto]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Obtener el contacto
    begin
      @contacto = Contacto.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Cambiar los valores de los atributos de acuerdo con los parámetros
    @contacto.attributes = params[:contacto]

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @tipos_de_documentos = TipoDeDocumento.where(:activo => true).collect{ |i| [i.nombre, i.id]}
    @tipo_de_documento_id = @contacto.tipo_de_documento_id
    @sexos = Sexo.find(:all).collect{ |s| [s.nombre, s.id] }
    @sexo_id = @contacto.sexo_id

    # Verificar la validez del objeto
    if @contacto.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if (@sexo_id && !(@sexos.collect{|s| s[1]}.member?(@sexo_id)) ||
          @tipo_de_documento_id && !(@tipos_de_documentos.collect{|s| s[1]}.member?(@tipo_de_documento_id)))
        redirect_to( root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre el incidente."
          }
        )
        return
      end

      # Registrar el usuario que realiza la modificación
      @contacto.updater_id = current_user.id

      # Guardar las modificaciones al convenio de administración
      @contacto.save
      redirect_to(@contacto,
        :flash => {:tipo => :ok, :titulo => 'El contacto se modificó correctamente.'}
      )
    else
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "edit"
    end
  end

end
