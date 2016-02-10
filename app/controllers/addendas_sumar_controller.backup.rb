# -*- encoding : utf-8 -*-
class AddendasSumarController < ApplicationController
  include ActionView::Helpers::NumberHelper
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

    respond_to do |format|
      format.odt do
          report = ODFReport::Report.new("lib/tasks/datos/plantillas/Modelo de adenda prestacional.odt") do |r|
            r.add_field :cgs_sumar_numero, @convenio_de_gestion.numero
            if @convenio_de_gestion.efector.grupo_de_efectores.tipo_de_efector == "PSB"
              r.add_field :efector_articulo, "la"
              r.add_field :o_a, "a"
            else
              r.add_field :efector_articulo, "el"
              r.add_field :o_a, "o"
            end
            r.add_field :efector_nombre, @convenio_de_gestion.efector.nombre
            referente = @convenio_de_gestion.efector.referente_al_dia(@addenda.fecha_de_inicio)
            if referente.present?
              if referente.contacto.sexo.present?
                if referente.contacto.sexo.codigo == "F"
                  r.add_field :articulo_contacto, "la"
                else
                  r.add_field :articulo_contacto, "el"
                end
              end
              r.add_field :contacto_mostrado, referente.contacto.mostrado
              if referente.contacto.tipo_de_documento.present?
                r.add_field :tipo_de_documento_codigo, referente.contacto.tipo_de_documento.codigo
              end
              if !referente.contacto.dni.blank?
                r.add_field :contacto_dni, number_with_delimiter(referente.contacto.dni, {:delimiter => "."})
              end
              if !referente.contacto.firma_primera_linea.blank?
                r.add_field :contacto_firma_primera_linea, referente.contacto.firma_primera_linea.strip
              end
              if !referente.contacto.firma_segunda_linea.blank?
                r.add_field :contacto_firma_segunda_linea, referente.contacto.firma_segunda_linea.strip
              end
              if !referente.contacto.firma_tercera_linea.blank?
                r.add_field :contacto_firma_tercera_linea, referente.contacto.firma_tercera_linea.strip
              end
            end
            if !@convenio_de_gestion.efector.domicilio.blank?
              r.add_field :efector_domicilio, @convenio_de_gestion.efector.domicilio.to_s.strip.gsub(".", ",")
            end

            @bajas_de_prestaciones = @addenda.prestaciones_autorizadas_baja.includes(:prestacion).order("prestaciones.codigo").collect{|pa| {codigo: pa.prestacion.codigo, nombre: pa.prestacion.nombre} }

            r.add_table("Bajas", @bajas_de_prestaciones, header: true) do |t|
              t.add_column(:prestacion_codigo, :codigo)
              t.add_column(:prestacion_nombre, :nombre)
            end

            @altas_de_prestaciones = @addenda.prestaciones_autorizadas_alta.includes(:prestacion).order("prestaciones.codigo").collect{|pa| {codigo: pa.prestacion.codigo, nombre: pa.prestacion.nombre} }

            r.add_table("Altas", @altas_de_prestaciones, header: true) do |t|
              t.add_column(:prestacion_codigo, :codigo)
              t.add_column(:prestacion_nombre, :nombre)
            end

            r.add_field :suscripcion_mes_y_anio, I18n.l(@addenda.fecha_de_suscripcion, :format => :month_and_year)

          end

        archivo = report.generate("lib/tasks/datos/documentos/Adenda prestacional #{@addenda.numero} - #{@convenio_de_gestion.efector.nombre}.odt")

        File.chmod(0644, "lib/tasks/datos/documentos/Adenda prestacional #{@addenda.numero} - #{@convenio_de_gestion.efector.nombre}.odt")

        send_file(archivo)
      end

      format.html do
      end
    end

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
    Prestacion.no_autorizadas(@convenio_de_gestion.efector.id).collect{
        |p| [p.codigo + " - " + p.nombre_corto, p.id]
      }
#_____________________________________________________________________________________________________________
#    @prestaciones_alta =
#      Prestacion.no_autorizadas_sumar(@convenio_de_gestion.efector.id).map {|grup| [grup.grupo_de_prestaciones_id, grup.nombre]}.uniq.collect { |g|
#        [ g[0] + " - " + g[1],
#          (Prestacion.no_autorizadas_sumar(@convenio_de_gestion.efector.id).where("grupo_pdss_id = ?", g[0]).collect { |p|
#            [p.codigo + " - " + p.nombre_corto, p.id]
#          })
#        ]
#      }






#    @prestaciones_baja =
#      PrestacionAutorizada.autorizadas(@convenio_de_gestion.efector.id).map {|grup| [grup.grupo_id, grup.grupo]}.uniq.collect { |g|
#        [ g[0] + " - " + g[1],
#          (PrestacionAutorizada.autorizadas(@convenio_de_gestion.efector.id).where("grupo = ?", g[0]).collect { |p|
#            [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id]
#          })
#        ]
#      }
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
    @prestacion_autorizada_ids = (params[:addenda_sumar][:prestacion_pdss_id])
    
    @convenio_degestion = ConvenioDeGestionSumar.find(params[:addenda_sumar][:convenio_de_gestion_sumar_id])

   #pres[0] y pres[1]     
    fecha_actual = Time.now
    @addenda = AddendaSumar.new()
    @addenda.creator_id = current_user.id
    @addenda.updater_id = current_user.id
    @addenda.convenio_de_gestion_sumar_id = params[:addenda_sumar][:convenio_de_gestion_sumar_id]
    @addenda.firmante = params[:addenda_sumar][:firmante]
    @addenda.fecha_de_suscripcion = parametro_fecha(params[:addenda_sumar], :fecha_de_suscripcion)
    @addenda.fecha_de_inicio = parametro_fecha(params[:addenda_sumar], :fecha_de_inicio)
    @addenda.observaciones = params[:addenda_sumar][:observaciones]
    @addenda.numero = params[:addenda_sumar][:numero]
   
    if @addenda.save

      @prestacion_autorizada_ids.each do |pres|

        actual = PrestacionPdssAutorizada.pres_autorizadas(@convenio_degestion.efector_id, fecha_actual, pres[0])
        if not actual.first
          #no se encontro la prestacion por lo que el efector no la tiene autorizada
          #hacemos un insert de la prestacion nueva siempre que se encuentre seleccionada
          if not pres[1].blank?
            #dar de alta
            @addenda.prestaciones_pdss_autorizadas_alta.build(
               :efector_id => @convenio_de_gestion.efector_id,
               :prestacion_pdss_id => pres[0],
               :fecha_de_inicio => @addenda.fecha_de_inicio,
               :autorizante_de_la_alta_type => "AddendaSumar"
             )
          end
        else
          #si esta y esta deseleccionada es que la da de baja
          if pres[1].blank?
            #la doy de baja
            @addenda.prestaciones_pdss_autorizadas_baja.buil(
               :efector_id => @convenio_de_gestion.efector_id,
               :prestacion_pdss_id => pres[0],
               :fecha_de_finalizacion => @addenda.fecha_de_inicio,
               :autorizante_de_la_baja_type => "AddendaSumar"
             )
          end
        end
      end
      redirect_to(@addenda,
         :flash => { :tipo => :ok, :titulo => 'La adenda se creó correctamente.' }
       )
    end
    render :action => "new"


    # # Crear una nueva adenda desde los parámetros
    # @addenda = AddendaSumar.new(params[:addenda_sumar])

    # prestaciones_alta = Prestacion.no_autorizadas_sumar(@convenio_de_gestion.efector.id).collect{
    #   |p| [p.codigo + " - " + p.nombre_corto, p.id]
    # }
    # prestaciones_baja = PrestacionAutorizada.autorizadas(@convenio_de_gestion.efector.id).collect{
    #   |p| [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id]
    # }

    # # Verificar la validez del objeto
    # if @addenda.valid?
    #   # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
    #   if ( @prestacion_autorizada_alta_ids.any?{|p_id| !((prestaciones_alta.collect{|p| p[1]}).member?(p_id.to_i))} ||
    #        @prestacion_autorizada_baja_ids.any?{|p_id| !((prestaciones_baja.collect{|p| p[1]}).member?(p_id.to_i))} )
    #     redirect_to( root_url,
    #       :flash => { :tipo => :error, :titulo => "La petición no es válida",
    #         :mensaje => "Se informará al administrador del sistema sobre el incidente."
    #       }
    #     )
    #     return
    #   end

    #   # Registrar el usuario que realiza la creación
    #   @addenda.creator_id = current_user.id
    #   @addenda.updater_id = current_user.id

    #   # Guardar la nueva addenda y sus prestaciones asociadas
    #   if @addenda.save
    #     @prestacion_autorizada_alta_ids.each do |prestacion_id|
    #       prestacion_autorizada_alta = PrestacionAutorizada.new
    #       prestacion_autorizada_alta.attributes = {
    #         :efector_id => @convenio_de_gestion.efector_id,
    #         :prestacion_id => prestacion_id,
    #         :fecha_de_inicio => @addenda.fecha_de_inicio
    #       }
    #       @addenda.prestaciones_autorizadas_alta << prestacion_autorizada_alta
    #     end
    #     @prestacion_autorizada_baja_ids.each do |prestacion_autorizada_id|
    #       prestacion_autorizada_baja = PrestacionAutorizada.find(prestacion_autorizada_id)
    #       prestacion_autorizada_baja.attributes = {
    #         :fecha_de_finalizacion => @addenda.fecha_de_inicio
    #       }
    #       @addenda.prestaciones_autorizadas_baja << prestacion_autorizada_baja
    #     end
    #   end

    #   # Redirigir a la nueva adenda creada
    #   redirect_to(@addenda,
    #     :flash => { :tipo => :ok, :titulo => 'La adenda se creó correctamente.' }
    #   )
    # else
    #   # Crear los objetos necesarios para regenerar la vista si hay algún error
    #   @prestaciones_alta =
    #     Prestacion.no_autorizadas_sumar(@convenio_de_gestion.efector.id).map {|grup| [grup.grupo_id, grup.grupo]}.uniq.collect { |g|
    #       [ g[0] + " - " + g[1],
    #         (Prestacion.no_autorizadas_sumar(@convenio_de_gestion.efector.id).where("grupo = ?", g[0]).collect { |p|
    #           [p.codigo + " - " + p.nombre_corto, p.id]
    #         })
    #       ]
    #     }

    #   @prestaciones_baja =
    #     PrestacionAutorizada.autorizadas(@convenio_de_gestion.efector.id).map {|grup| [grup.grupo_id, grup.grupo]}.uniq.collect { |g|
    #       [ g[0] + " - " + g[1], 
    #         (PrestacionAutorizada.autorizadas(@convenio_de_gestion.efector.id).where("grupo = ?", g[0]).collect { |p|
    #           [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id]
    #         })
    #       ]
    #     }
    #   # Si no pasa las validaciones, volver a mostrar el formulario con los errores
    #   render :action => "new"
    # end
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
