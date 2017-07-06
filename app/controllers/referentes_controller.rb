# -*- encoding : utf-8 -*-
class ReferentesController < ApplicationController
  before_filter :authenticate_user!

  # GET /referentes/new
  def new
    # Verificar los permisos del usuario
    if cannot? :create, Referente
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que se hayan pasado los parámetros necesarios
    if !params[:efector_id]
      redirect_to(
        root_url,
        :flash => {:tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Obtener el efector asociado
    begin
      @efector = Efector.find(params[:efector_id])
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
    @referente = Referente.new
    @contactos =
      Contacto.find(:all, :order => "apellidos, nombres, mostrado").collect{ |c|
        [c.apellidos  ? c.apellidos + ", " + c.nombres : c.mostrado, c.id]
      }
  end

  # GET /referentes/:id/edit
  def edit
    # Verificar los permisos del usuario
    if cannot? :update, Referente
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el referente
    begin
      @referente = Referente.find(params[:id], :include => :efector)
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Crear los objetos necesarios para la vista
    @efector = @referente.efector
    @contactos =
      Contacto.find(:all, :order => "apellidos, nombres, mostrado").collect{ |c|
        [c.apellidos ? c.apellidos + ", " + c.nombres : c.mostrado, c.id]
      }
  end

  # POST /referentes
  def create
    # Verificar los permisos del usuario
    if cannot? :create, Referente
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar si la petición contiene los parámetros esperados
    if !params[:referente] || !params[:referente][:efector_id]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Obtener el efector asociado
    begin
      @efector = Efector.find(params[:referente][:efector_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to(
        root_url,
        :flash => {:tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Crear un nuevo referente desde los parámetros
    @referente = Referente.new(params[:referente])

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @contactos =
      Contacto.find(:all, :order => "apellidos, nombres, mostrado").collect{ |c|
        [c.apellidos ? c.apellidos + ", " + c.nombres : c.mostrado, c.id]
      }

    # Verificar la validez del objeto
    if @referente.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if ( !@contactos.collect{ |i| i[1] }.member?(@referente.contacto_id) )
        redirect_to( root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre el incidente."
          }
        )
        return
      end

      # Registrar el usuario que realiza la creación
      @referente.creator_id = current_user.id
      @referente.updater_id = current_user.id

      # Terminar el periodo de actividad del referente actual (si existiera uno)
      referente_actual = Referente.actual_del_efector(@efector.id)
      if referente_actual && @referente.fecha_de_inicio > referente_actual.fecha_de_inicio
        referente_actual.update_attributes({:fecha_de_finalizacion => @referente.fecha_de_inicio})
      end

      # Guardar el nuevo referente
      @referente.save
      redirect_to(referentes_del_efector_path(@efector),
        :flash => { :tipo => :ok, :titulo => 'El referente se creó correctamente.' }
      )
    else
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "new"
    end
  end

  # PUT /referentes/:id
  def update
    # Verificar los permisos del usuario
    if cannot? :update, Referente
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que la petición contenga los parámetros esperados
    if !params[:referente]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Obtener el referente
    begin
      @referente = Referente.find(params[:id], :include => :efector)
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Actualizar los valores de los atributos para validar el registro antes de guardarlo
    @referente.attributes = params[:referente]

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @contactos =
      Contacto.find(:all, :order => "apellidos, nombres, mostrado").collect{ |c|
        [c.apellidos ? c.apellidos + ", " + c.nombres : c.mostrado, c.id]
      }
    @efector = @referente.efector

    # Verificar la validez del objeto
    if @referente.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if ( !@contactos.collect{ |i| i[1] }.member?(@referente.contacto_id) )
        redirect_to(root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre este incidente."
          }
        )
        return
      end

      # Registrar el usuario que realiza la modificación
      @referente.updater_id = current_user.id

      # Guardar el referente
      @referente.save
      redirect_to(referentes_del_efector_path(@efector),
        :flash => {:tipo => :ok, :titulo => 'Las modificaciones al referente se guardaron correctamente.' }
      )
    else
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "edit"
    end
  end
end
