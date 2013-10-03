# -*- encoding : utf-8 -*-
class ConveniosDeAdministracionSumarController < ApplicationController
  before_filter :authenticate_user!

  # GET /convenios_de_administracion_sumar
  def index
    # Verificar los permisos del usuario
    if cannot? :read, ConvenioDeAdministracionSumar
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el listado de convenios
    @convenios_de_administracion =
      ConvenioDeAdministracionSumar.paginate( :page => params[:page], :per_page => 20,
        :include => [:efector, :administrador], :order => "updated_at DESC"
      )
  end

  # GET /convenios_de_administracion_sumar/:id
  def show
    # Verificar los permisos del usuario
    if cannot? :read, ConvenioDeAdministracionSumar
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el convenio
    begin
      @convenio_de_administracion = ConvenioDeAdministracionSumar.find(params[:id], :include => [:efector, :administrador])
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
  end

  # GET /convenios_de_administracion_sumar/new
  def new
    # Verificar los permisos del usuario
    if cannot? :create, ConvenioDeAdministracionSumar
      redirect_to(root_url,
        :flash => {:tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear los objetos necesarios para la vista
    @convenio_de_administracion = ConvenioDeAdministracionSumar.new
    @efectores = Efector.find(:all, :order => :nombre).collect{ |e| [e.nombre_corto, e.id] }
    @efector_id = nil
    @firmantes = Referente.find(:all, :include => :contacto).collect{ |r|
      [r.contacto.mostrado, r.id, {:class => r.efector_id}]
    }
    @firmante_id = nil
    @administradores = Efector.find(:all).collect{ |a| [a.nombre_corto, a.id] }
    @administrador_id = nil
  end

  # GET /convenios_de_administracion_sumar/:id/edit
  def edit
    # Verificar los permisos del usuario
    if cannot? :update, ConvenioDeAdministracionSumar
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el convenio
    begin
      @convenio_de_administracion = ConvenioDeAdministracionSumar.find(params[:id], :include => [:efector, :administrador])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
    @firmantes = Referente.where(:efector_id => @convenio_de_administracion.administrador_id).collect{ |r|
      [r.contacto.mostrado, r.id, {:class => r.efector_id}]
    }
    @firmante_id = @convenio_de_administracion.firmante_id
  end

  # POST /convenios_de_administracion_sumar
  def create
    # Verificar los permisos del usuario
    if cannot? :create, ConvenioDeAdministracionSumar
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que la petición contenga los parámetros esperados
    if !params[:convenio_de_administracion_sumar]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Crear un nuevo convenio desde los parámetros
    @convenio_de_administracion = ConvenioDeAdministracionSumar.new(params[:convenio_de_administracion_sumar])

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @efectores = Efector.find(:all, :order => :nombre).collect{ |e| [e.nombre_corto, e.id] }
    @efector_id = @convenio_de_administracion.efector_id
    @firmantes = Referente.find(:all, :include => :contacto).collect{ |r|
      [r.contacto.mostrado, r.id, {:class => r.efector_id}]
    }
    @firmante_id = @convenio_de_administracion.firmante_id
    @administradores = Efector.find(:all).collect{ |a| [a.nombre_corto, a.id] }
    @administrador_id = @convenio_de_administracion.administrador_id

    # Verificar la validez del objeto
    if @convenio_de_administracion.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if !( @efectores.collect{ |i| i[1] }.member?(params[:convenio_de_administracion_sumar][:efector_id].to_i) &&
            @administradores.collect{ |i| i[1] }.member?(params[:convenio_de_administracion_sumar][:administrador_id].to_i) &&
            @firmantes.collect{|f| f[1]}.member?(@firmante_id.to_i) )
        redirect_to(root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre este incidente."
          }
        )
        return
      end

      # Registrar el usuario que realiza la creación
      @convenio_de_administracion.creator_id = current_user.id
      @convenio_de_administracion.updater_id = current_user.id

      # Guardar el nuevo convenio
      @convenio_de_administracion.save
      redirect_to(@convenio_de_administracion,
        :flash => { :tipo => :ok, :titulo => 'El convenio de administración se creó correctamente.' }
      )
    else
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "new"
    end
  end

  # PUT /convenios_de_administracion/:id
  def update
    # Verificar los permisos del usuario
    if cannot? :update, ConvenioDeAdministracionSumar
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que la petición contenga los parámetros esperados
    if !params[:convenio_de_administracion_sumar]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Obtener el convenio
    begin
      @convenio_de_administracion = ConvenioDeAdministracionSumar.find(params[:id], :include => [:efector, :administrador])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Cambiar los valores de los atributos de acuerdo con los parámetros
    @convenio_de_administracion.attributes = params[:convenio_de_administracion_sumar]

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @firmantes = Referente.where(:efector_id => @convenio_de_administracion.administrador_id).collect{ |r|
      [r.contacto.mostrado, r.id, {:class => r.efector_id}]
    }
    @firmante_id = @convenio_de_administracion.firmante_id

    # Verificar la validez del objeto
    if @convenio_de_administracion.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if !(@firmantes.collect{|f| f[1]}.member?(@firmante_id.to_i))
        redirect_to(root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre este incidente."
          }
        )
        return
      end
      # Registrar el usuario que realiza la modificación
      @convenio_de_administracion.updater_id = current_user.id

      # Guardar las modificaciones al convenio de administración
      @convenio_de_administracion.save
      redirect_to(@convenio_de_administracion,
        :flash => {:tipo => :ok, :titulo => 'Las modificaciones al convenio de administración se guardaron correctamente.' }
      )
    else
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "edit"
    end
  end

end
