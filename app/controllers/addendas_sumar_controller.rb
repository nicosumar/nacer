# -*- encoding : utf-8 -*-
class AddendasSumarController < ApplicationController
  before_filter :authenticate_user!

  # GET /addendas_sumar
  def index
    # Verificar los permisos del usuario
    if cannot? :read, AddendaSumar
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el listado de addendas
    @addendas =
      AddendaSumar.paginate(:page => params[:page], :per_page => 20, :include => {:convenio_de_gestion_sumar => :efector},
        :order => "updated_at DESC"
      )
  end

  # GET /addendas_sumar/:id
  def show
    # Verificar los permisos del usuario
    if cannot? :read, AddendaSumar
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener la adenda solicitada
    begin
      @addenda =
        AddendaSumar.find( params[:id],
          :include => [ {:convenio_de_gestion_sumar => :efector},
            {:prestaciones_autorizadas_alta => :prestacion},
            {:prestaciones_autorizadas_baja => :prestacion}
          ]
        )
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La adenda solicitada no existe",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
    end
    @convenio_de_gestion = @addenda.convenio_de_gestion_sumar
  end

  # GET /addendas_sumar/new
  def new
    # Verificar los permisos del usuario
    if cannot? :create, AddendaSumar
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Para crear addendas, debe accederse desde la página del convenio que se modificará
    if !params[:convenio_de_gestion_sumar_id]
      redirect_to( convenios_de_gestion_sumar_url,
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
      @convenio_de_gestion = ConvenioDeGestionSumar.find(params[:convenio_de_gestion_sumar_id])
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
    @addenda = AddendaSumar.new
    @prestaciones_alta =
      Prestacion.no_autorizadas_sumar(@convenio_de_gestion.efector.id).map {|grup| [grup.grupo_id, grup.grupo]}.uniq.collect { |g|
        [ g[0] + " - " + g[1],
          (Prestacion.no_autorizadas_sumar(@convenio_de_gestion.efector.id).where("grupo = ?", g[0]).collect { |p|
            [p.codigo + " - " + p.nombre_corto, p.id]
          })
        ]
      }

    @prestaciones_baja =
      PrestacionAutorizada.autorizadas(@convenio_de_gestion.efector.id).map {|grup| [grup.grupo_id, grup.grupo]}.uniq.collect { |g|
        [ g[0] + " - " + g[1],
          (PrestacionAutorizada.autorizadas(@convenio_de_gestion.efector.id).where("grupo = ?", g[0]).collect { |p|
            [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id]
          })
        ]
      }
    @prestacion_autorizada_alta_ids = []
    @prestacion_autorizada_baja_ids = []
  end

  # GET /addendas_sumar/:id/edit
  def edit
    # Verificar los permisos del usuario
    if cannot? :update, AddendaSumar
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener la adenda
    begin
      @addenda = AddendaSumar.find( params[:id],
        :include => [
          {:convenio_de_gestion_sumar => :efector},
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
    @convenio_de_gestion = @addenda.convenio_de_gestion_sumar

    @prestaciones_alta =
      Prestacion.no_autorizadas_sumar_antes_del_dia(@convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).map {|grup| [grup.grupo_id, grup.grupo]}.uniq.collect { |g|
        [ g[0] + " - " + g[1],
          (Prestacion.no_autorizadas_sumar_antes_del_dia(@convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).where("grupo = ?", g[0]).collect { |p|
            [p.codigo + " - " + p.nombre_corto, p.id]
          })
        ]
      }
    @prestaciones_baja =
      PrestacionAutorizada.autorizadas_antes_del_dia(@convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).map {|grup| [grup.grupo_id, grup.grupo]}.uniq.collect { |g|
        [ g[0] + " - " + g[1],
          (PrestacionAutorizada.autorizadas_antes_del_dia(@convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).where("grupo = ?", g[0]).collect { |p|
            [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id]
          })
        ]
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

  # POST /addendas_sumar
  def create
    # Verificar los permisos del usuario
    if cannot? :create, AddendaSumar
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar si la petición contiene los parámetros esperados
    if !params[:addenda_sumar] || !params[:addenda_sumar][:convenio_de_gestion_sumar_id]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Obtener el convenio de gestión asociado
    begin
      @convenio_de_gestion = ConvenioDeGestionSumar.find(params[:addenda_sumar][:convenio_de_gestion_sumar_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end
    
    # Guardar las prestaciones seleccionadas para dar de alta y de baja
    @prestacion_autorizada_alta_ids = (params[:addenda_sumar].delete(:prestacion_autorizada_alta_ids).reject(&:blank?) || []).uniq
    @prestacion_autorizada_baja_ids = (params[:addenda_sumar].delete(:prestacion_autorizada_baja_ids).reject(&:blank?) || []).uniq

    # Crear una nueva adenda desde los parámetros
    @addenda = AddendaSumar.new(params[:addenda_sumar])

    prestaciones_alta = Prestacion.no_autorizadas_sumar(@convenio_de_gestion.efector.id).collect{
      |p| [p.codigo + " - " + p.nombre_corto, p.id]
    }
    prestaciones_baja = PrestacionAutorizada.autorizadas(@convenio_de_gestion.efector.id).collect{
      |p| [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id]
    }

    # Verificar la validez del objeto
    if @addenda.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if ( @prestacion_autorizada_alta_ids.any?{|p_id| !((prestaciones_alta.collect{|p| p[1]}).member?(p_id.to_i))} ||
           @prestacion_autorizada_baja_ids.any?{|p_id| !((prestaciones_baja.collect{|p| p[1]}).member?(p_id.to_i))} )
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
      # Crear los objetos necesarios para regenerar la vista si hay algún error
      @prestaciones_alta =
        Prestacion.no_autorizadas_sumar(@convenio_de_gestion.efector.id).map {|grup| [grup.grupo_id, grup.grupo]}.uniq.collect { |g|
          [ g[0] + " - " + g[1],
            (Prestacion.no_autorizadas_sumar(@convenio_de_gestion.efector.id).where("grupo = ?", g[0]).collect { |p|
              [p.codigo + " - " + p.nombre_corto, p.id]
            })
          ]
        }

      @prestaciones_baja =
        PrestacionAutorizada.autorizadas(@convenio_de_gestion.efector.id).map {|grup| [grup.grupo_id, grup.grupo]}.uniq.collect { |g|
          [ g[0] + " - " + g[1], 
            (PrestacionAutorizada.autorizadas(@convenio_de_gestion.efector.id).where("grupo = ?", g[0]).collect { |p|
              [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id]
            })
          ]
        }
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "new"
    end
  end

  # PUT /addendas_sumar/:id
  def update
    # Verificar los permisos del usuario
    if cannot? :update, AddendaSumar
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar si la petición contiene los parámetros esperados
    if !params[:addenda_sumar]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Obtener la addenda que se actualizará y su convenio de gestión
    begin
      @addenda = AddendaSumar.find(params[:id], :include => [{:convenio_de_gestion_sumar => :efector},
        {:prestaciones_autorizadas_alta => :prestacion}, {:prestaciones_autorizadas_baja => :prestacion}])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end
    @convenio_de_gestion = @addenda.convenio_de_gestion_sumar

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    prestaciones_alta = Prestacion.no_autorizadas_sumar_antes_del_dia(@convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).collect{
        |p| [p.codigo + " - " + p.nombre_corto, p.id]
      }
    prestaciones_baja = PrestacionAutorizada.autorizadas_antes_del_dia(@convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).collect{
        |p| [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id]
      }
    
    # Preservar las prestaciones seleccionadas para dar de alta y de baja
    @prestacion_autorizada_alta_ids = (params[:addenda_sumar].delete(:prestacion_autorizada_alta_ids).reject(&:blank?) || []).uniq
    @prestacion_autorizada_baja_ids = (params[:addenda_sumar].delete(:prestacion_autorizada_baja_ids).reject(&:blank?) || []).uniq

    # Actualizar los valores de los atributos no protegidos por asignación masiva
    @addenda.attributes = params[:addenda_sumar]

    # Verificar la validez del objeto
    if @addenda.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if ( @prestacion_autorizada_alta_ids.any?{|p_id| !((prestaciones_alta.collect{|p| p[1]}).member?(p_id.to_i))} ||
           @prestacion_autorizada_baja_ids.any?{|p_id| !((prestaciones_baja.collect{|p| p[1]}).member?(p_id.to_i))} )
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
      # Crear los objetos necesarios para regenerar la vista si hay algún error
      @prestaciones_alta =
        Prestacion.no_autorizadas_sumar_antes_del_dia(@convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).map {|grup| [grup.grupo_id, grup.grupo]}.uniq.collect { |g|
          [ g[0] + " - " + g[1], 
            (Prestacion.no_autorizadas_sumar_antes_del_dia(@convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).where("grupo = ?", g[0]).collect { |p|
              [p.codigo + " - " + p.nombre_corto, p.id]
            })
          ]
        }

      @prestaciones_baja =
        PrestacionAutorizada.autorizadas_antes_del_dia(@convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).map {|grup| [grup.grupo_id, grup.grupo]}.uniq.collect { |g|
          [ g[0] + " - " + g[1], 
            (PrestacionAutorizada..autorizadas_antes_del_dia(@convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).where("grupo = ?", g[0]).collect { |p|
              [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id]
            })
          ]
        }
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "edit"
    end
  end

end
