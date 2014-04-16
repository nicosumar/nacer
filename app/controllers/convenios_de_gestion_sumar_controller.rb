# -*- encoding : utf-8 -*-
class ConveniosDeGestionSumarController < ApplicationController
  include ActionView::Helpers::NumberHelper

  before_filter :authenticate_user!

  # GET /convenios_de_gestion_sumar
  def index
    # Verificar los permisos del usuario
    if cannot? :read, ConvenioDeGestionSumar
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el listado de convenios
    @convenios_de_gestion =
      ConvenioDeGestionSumar.paginate(
        :page => params[:page], :per_page => 20, :include => :efector, :order => "updated_at DESC"
      )
  end

  # GET /convenios_de_gestion_sumar/:id
  def show
    # Verificar los permisos del usuario
    if cannot? :read, ConvenioDeGestionSumar
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
        ConvenioDeGestionSumar.find(params[:id],
          :include => [
            :efector, {:prestaciones_autorizadas => :prestacion},
            { :addendas_sumar => [ {:prestaciones_autorizadas_alta => :prestacion}, {:prestaciones_autorizadas_baja => :prestacion} ] }
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

    respond_to do |format|
      format.odt do
        if @convenio_de_gestion.efector.es_administrado?
          report = ODFReport::Report.new("lib/tasks/datos/plantillas/Modelo de compromiso de gestión para administrados.odt") do |r|
            r.add_field :cgs_sumar_numero, @convenio_de_gestion.numero
            r.add_field :nombre_administrador, @convenio_de_gestion.efector.administrador_sumar.nombre
            if @convenio_de_gestion.efector.grupo_de_efectores.tipo_de_efector == "PSB"
              r.add_field :efector_articulo, "la"
              r.add_field :o_a, "a"
            else
              r.add_field :efector_articulo, "el"
              r.add_field :o_a, "o"
            end
            r.add_field :efector_nombre, @convenio_de_gestion.efector.nombre
            if @convenio_de_gestion.firmante.present?
              if @convenio_de_gestion.firmante.contacto.sexo.present?
                if @convenio_de_gestion.firmante.contacto.sexo.codigo == "F"
                  r.add_field :articulo_contacto, "la"
                else
                  r.add_field :articulo_contacto, "el"
                end
              end
              r.add_field :contacto_mostrado, @convenio_de_gestion.firmante.contacto.mostrado
              if @convenio_de_gestion.firmante.contacto.tipo_de_documento.present?
                r.add_field :tipo_de_documento_codigo, @convenio_de_gestion.firmante.contacto.tipo_de_documento.codigo
              end
              if !@convenio_de_gestion.firmante.contacto.dni.blank?
                r.add_field :contacto_dni, number_with_delimiter(@convenio_de_gestion.firmante.contacto.dni, {:delimiter => "."})
              end
              if !@convenio_de_gestion.firmante.contacto.firma_primera_linea.blank?
                r.add_field :contacto_firma_primera_linea, @convenio_de_gestion.firmante.contacto.firma_primera_linea.strip
              end
              if !@convenio_de_gestion.firmante.contacto.firma_segunda_linea.blank?
                r.add_field :contacto_firma_segunda_linea, @convenio_de_gestion.firmante.contacto.firma_segunda_linea.strip
              end
              if !@convenio_de_gestion.firmante.contacto.firma_tercera_linea.blank?
                r.add_field :contacto_firma_tercera_linea, @convenio_de_gestion.firmante.contacto.firma_tercera_linea.strip
              end
            end
            if !@convenio_de_gestion.efector.domicilio.blank?
              r.add_field :efector_domicilio, @convenio_de_gestion.efector.domicilio.to_s.strip.gsub(".", ",")
            end
            if !@convenio_de_gestion.email.blank?
              r.add_field :cgs_correo_electronico, @convenio_de_gestion.email.strip
            end
            if !@convenio_de_gestion.efector.telefonos.blank?
              r.add_field :efector_fax, @convenio_de_gestion.efector.telefonos.strip
            end
            if !@convenio_de_gestion.efector.codigo_postal.blank?
              r.add_field :efector_codigo_postal, @convenio_de_gestion.efector.codigo_postal.strip
            end
            if !@convenio_de_gestion.efector.administrador_sumar.numero_de_cuenta_principal.blank?
              r.add_field :administrador_cuenta_principal, @convenio_de_gestion.efector.administrador_sumar.numero_de_cuenta_principal.strip
            end
            if !@convenio_de_gestion.efector.administrador_sumar.denominacion_cuenta_principal.blank?
              r.add_field :administrador_denominacion_principal, @convenio_de_gestion.efector.administrador_sumar.denominacion_cuenta_principal.strip
            end
            if !@convenio_de_gestion.efector.administrador_sumar.banco_cuenta_principal.blank?
              r.add_field :administrador_banco_principal, @convenio_de_gestion.efector.administrador_sumar.banco_cuenta_principal.strip
            end
            if !@convenio_de_gestion.efector.administrador_sumar.sucursal_cuenta_principal.blank?
              r.add_field :administrador_sucursal_principal, @convenio_de_gestion.efector.administrador_sumar.sucursal_cuenta_principal.strip
            end
            if !@convenio_de_gestion.efector.administrador_sumar.numero_de_cuenta_secundaria.blank?
              otra_cuenta =
                " y de la cuenta bancaria Nº " + \
                @convenio_de_gestion.efector.administrador_sumar.numero_de_cuenta_secundaria.strip + " “" + \
                @convenio_de_gestion.efector.administrador_sumar.denominacion_cuenta_secundaria.to_s.strip + "” abierta en la entidad " + \
                @convenio_de_gestion.efector.administrador_sumar.banco_cuenta_secundaria.to_s.strip + ", sucursal " + \
                @convenio_de_gestion.efector.administrador_sumar.sucursal_cuenta_secundaria.to_s.strip
              r.add_field :otra_cuenta, otra_cuenta
            else
              r.add_field :otra_cuenta, ""
            end
            r.add_field :cgs_suscripcion_mes_y_anio, I18n.l(@convenio_de_gestion.fecha_de_suscripcion, :format => :month_and_year)

            autorizadas_ids = @convenio_de_gestion.prestaciones_autorizadas.collect{|p| p.prestacion_id}
            Prestacion.where("objeto_de_la_prestacion_id IS NOT NULL", :order => :id).each do |p|
              if autorizadas_ids.member?(p.id)
                r.add_field ("p" + p.id.to_s).to_sym, "SI"
              else
                r.add_field ("p" + p.id.to_s).to_sym, "NO"
              end
            end
          end
        else
          # Efector no administrado
          report = ODFReport::Report.new("lib/tasks/datos/plantillas/Modelo de compromiso de gestión para no administrados.odt") do |r|
            r.add_field :cgs_sumar_numero, @convenio_de_gestion.numero
            if @convenio_de_gestion.efector.grupo_de_efectores.tipo_de_efector == "HOS"
              r.add_field :efector_articulo, "el"
              r.add_field :o_a, "o"
            else
              r.add_field :efector_articulo, "la"
              r.add_field :o_a, "a"
            end
            r.add_field :efector_nombre, @convenio_de_gestion.efector.nombre
            if @convenio_de_gestion.firmante.present?
              if @convenio_de_gestion.firmante.contacto.sexo.present?
                if @convenio_de_gestion.firmante.contacto.sexo.codigo == "F"
                  r.add_field :articulo_contacto, "la"
                else
                  r.add_field :articulo_contacto, "el"
                end
              end
              r.add_field :contacto_mostrado, @convenio_de_gestion.firmante.contacto.mostrado.strip
              if @convenio_de_gestion.firmante.contacto.tipo_de_documento.present?
                r.add_field :tipo_de_documento_codigo, @convenio_de_gestion.firmante.contacto.tipo_de_documento.codigo
              end
              if !@convenio_de_gestion.firmante.contacto.dni.blank?
                r.add_field :contacto_dni, number_with_delimiter(@convenio_de_gestion.firmante.contacto.dni, {:delimiter => "."})
              end
              if !@convenio_de_gestion.firmante.contacto.firma_primera_linea.blank?
                r.add_field :contacto_firma_primera_linea, @convenio_de_gestion.firmante.contacto.firma_primera_linea.strip
              end
              if !@convenio_de_gestion.firmante.contacto.firma_segunda_linea.blank?
                r.add_field :contacto_firma_segunda_linea, @convenio_de_gestion.firmante.contacto.firma_segunda_linea.strip
              end
              if !@convenio_de_gestion.firmante.contacto.firma_tercera_linea.blank?
                r.add_field :contacto_firma_tercera_linea, @convenio_de_gestion.firmante.contacto.firma_tercera_linea.strip
              end
            end
            if !@convenio_de_gestion.efector.domicilio.blank?
              r.add_field :efector_domicilio, @convenio_de_gestion.efector.domicilio.gsub(".", ",").to_s.strip
            end
            if !@convenio_de_gestion.email.blank?
              r.add_field :cgs_correo_electronico, @convenio_de_gestion.email.to_s.strip
            end
            if !@convenio_de_gestion.efector.telefonos.blank?
              r.add_field :efector_fax, @convenio_de_gestion.efector.telefonos.to_s.strip
            end
            if !@convenio_de_gestion.efector.codigo_postal.blank?
              r.add_field :efector_codigo_postal, @convenio_de_gestion.efector.codigo_postal.to_s.strip
            end
            if !@convenio_de_gestion.efector.numero_de_cuenta_principal.blank?
              r.add_field :efector_cuenta_principal, @convenio_de_gestion.efector.numero_de_cuenta_principal.to_s.strip
            end
            if !@convenio_de_gestion.efector.denominacion_cuenta_principal.blank?
              r.add_field :efector_denominacion_principal, @convenio_de_gestion.efector.denominacion_cuenta_principal.to_s.strip
            end
            if !@convenio_de_gestion.efector.banco_cuenta_principal.blank?
              r.add_field :efector_banco_principal, @convenio_de_gestion.efector.banco_cuenta_principal.to_s.strip
            end
            if !@convenio_de_gestion.efector.sucursal_cuenta_principal.blank?
              r.add_field :efector_sucursal_principal, @convenio_de_gestion.efector.sucursal_cuenta_principal.to_s.strip
            end
            if !@convenio_de_gestion.efector.banco_cuenta_secundaria.blank?
              otra_cuenta =
                " y de la cuenta bancaria Nº " + \
                @convenio_de_gestion.efector.numero_de_cuenta_secundaria.to_s.strip + " “" + \
                @convenio_de_gestion.efector.denominacion_cuenta_secundaria.to_s.strip + "” abierta en la entidad " + \
                @convenio_de_gestion.efector.banco_cuenta_secundaria.to_s.strip + ", sucursal " + \
                @convenio_de_gestion.efector.sucursal_cuenta_secundaria.to_s.strip
              r.add_field :otra_cuenta, otra_cuenta
            else
              r.add_field :otra_cuenta, ""
            end
            r.add_field :cgs_suscripcion_mes_y_anio, I18n.l(@convenio_de_gestion.fecha_de_suscripcion, :format => :month_and_year)

            autorizadas_ids = @convenio_de_gestion.prestaciones_autorizadas.collect{|p| p.prestacion_id}
            Prestacion.where("objeto_de_la_prestacion_id IS NOT NULL", :order => :id).each do |p|
              if autorizadas_ids.member?(p.id)
                r.add_field ("p" + p.id.to_s).to_sym, "SI"
              else
                r.add_field ("p" + p.id.to_s).to_sym, "NO"
              end
            end
          end
        end

        archivo = report.generate("lib/tasks/datos/documentos/Compromiso de gestión - #{@convenio_de_gestion.efector.nombre}.odt")
        File.chmod(0644, "lib/tasks/datos/documentos/Compromiso de gestión - #{@convenio_de_gestion.efector.nombre}.odt")

        send_file(archivo)
      end

      format.html do
      end
    end

  end

  # GET /convenios_de_gestion_sumar/new
  def new
    # Verificar los permisos del usuario
    if cannot? :create, ConvenioDeGestionSumar
      redirect_to(root_url,
        :flash => {:tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear los objetos necesarios para la vista
    @convenio_de_gestion = ConvenioDeGestionSumar.new
    @efectores = Efector.where(
      "NOT EXISTS (
        SELECT * FROM convenios_de_gestion_sumar
          WHERE convenios_de_gestion_sumar.efector_id = efectores.id
       )", :order => :nombre).collect{ |e| [e.nombre_corto, e.id] }
    @efector_id = nil
    @firmantes = Referente.find(:all, :include => :contacto).collect{ |r|
      [r.contacto.mostrado, r.id, {:class => r.efector_id}]
    }
    @firmante_id = nil
    @prestaciones =
      Prestacion.where("objeto_de_la_prestacion_id IS NOT NULL").order(:codigo).collect{
        |p| [p.codigo + " - " + p.nombre_corto, p.id]
      }
    @prestacion_autorizada_ids = []
  end

  # GET /convenios_de_gestion_sumar/:id/edit
  def edit
    # Verificar los permisos del usuario
    if cannot? :update, ConvenioDeGestionSumar
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el convenio
    begin
      @convenio_de_gestion = ConvenioDeGestionSumar.find(params[:id], :include => [:efector, :prestaciones_autorizadas, :addendas_sumar])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear los objetos necesarios para generar la vista
    @prestaciones =
      Prestacion.where("objeto_de_la_prestacion_id IS NOT NULL").order(:codigo).collect{
        |p| [p.codigo + " - " + p.nombre_corto, p.id]
      }
    @prestacion_autorizada_ids = @convenio_de_gestion.prestaciones_autorizadas.collect{ |p| p.prestacion_id }
    @firmantes = Referente.where(:efector_id => @convenio_de_gestion.efector_id).collect{ |r|
      [r.contacto.mostrado, r.id, {:class => r.efector_id}]
    }
    @firmante_id = @convenio_de_gestion.firmante_id
  end

  # POST /convenios_de_gestion_sumar
  def create
    # Verificar los permisos del usuario
    if cannot? :create, ConvenioDeGestionSumar
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que la petición contenga los parámetros esperados
    if !params[:convenio_de_gestion_sumar]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Guardar las prestaciones seleccionadas para luego rellenar la tabla asociada si se graba correctamente
    @prestacion_autorizada_ids = params[:convenio_de_gestion_sumar].delete(:prestacion_autorizada_ids).reject(&:blank?) || []
    migrar_prestaciones = params[:migrar_prestaciones]

    # Crear un nuevo convenio desde los parámetros
    @convenio_de_gestion = ConvenioDeGestionSumar.new(params[:convenio_de_gestion_sumar])

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @efectores = Efector.find(:all, :order => :nombre).collect{ |e| [e.nombre_corto, e.id] }
    @efector_id = @convenio_de_gestion.efector_id
    @prestaciones =
      Prestacion.where("objeto_de_la_prestacion_id IS NOT NULL").order(:codigo).collect{
        |p| [p.codigo + " - " + p.nombre_corto, p.id]
      }
    @firmantes = Referente.find(:all, :include => [:contacto, :efector]).collect{ |r|
      [r.contacto.mostrado, r.id, {:class => r.efector_id}]
    }
    @firmante_id = @convenio_de_gestion.firmante_id

    # Verificar la validez del objeto
    if @convenio_de_gestion.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if ( !@efectores.collect{ |i| i[1] }.member?(@efector_id) ||
           @prestacion_autorizada_ids.any?{|p_id| !((@prestaciones.collect{|p| p[1]}).member?(p_id.to_i))} ||
           @firmante_id.present? && !@firmantes.collect{|f| f[1]}.member?(@firmante_id.to_i) )
        redirect_to(root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre este incidente."
          }
        )
        return
      end

      # Al crear el nuevo convenio de gestión, deben deshabilitarse todas las prestaciones que el efector tenía
      # autorizadas
      @convenio_de_gestion.efector.prestaciones_autorizadas.where("fecha_de_finalizacion IS NULL").each do |p|
        p.update_attributes(:fecha_de_finalizacion => @convenio_de_gestion.fecha_de_inicio)
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

      # Verificamos si se ha solicitado la migración de prestaciones (y que en este caso no se seleccionaran prestaciones manualmente)
      if migrar_prestaciones == "1" && @convenio_de_gestion.prestaciones_autorizadas.size == 0
        ActiveRecord::Base.connection.execute "
          INSERT INTO prestaciones_autorizadas
            (efector_id, prestacion_id, fecha_de_inicio, autorizante_al_alta_id, autorizante_al_alta_type,
            created_at, updated_at, creator_id, updater_id)
            SELECT DISTINCT ON (efector_id, prestacion_sumar_id)
              cgs.efector_id efector_id,
              prestacion_sumar_id prestacion_id,
              cgs.fecha_de_inicio fecha_de_inicio,
              cgs.id autorizante_al_alta_id,
              'ConvenioDeGestionSumar'::text autorizante_al_alta_type,
              now()::date created_at,
              now()::date updated_at,
              '1'::integer creator_id,
              '1'::integer updater_id
              FROM
                convenios_de_gestion_sumar cgs
                JOIN efectores ef ON ef.id = cgs.efector_id
                JOIN prestaciones_autorizadas pa ON (
                  pa.efector_id = cgs.efector_id
                  AND pa.fecha_de_finalizacion = cgs.fecha_de_inicio
                )
                JOIN prestaciones_nacer_sumar pns ON pns.prestacion_nacer_id = pa.prestacion_id
                JOIN asignaciones_de_precios ap ON (
                  ap.nomenclador_id = '5'  -- TODO: Cambiar este valor fijo por una búsqueda
                  AND ap.area_de_prestacion_id = ef.area_de_prestacion_id
                  AND ap.prestacion_id = pns.prestacion_sumar_id
                )
              WHERE cgs.id IN (
                #{@convenio_de_gestion.id}
              );
        "
      end

      redirect_to(@convenio_de_gestion,
        :flash => { :tipo => :ok, :titulo => 'El convenio de gestión se creó correctamente.' }
      )
    else
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "new"
    end
  end

  # PUT /convenios_de_gestion_sumar/:id
  def update
    # Verificar los permisos del usuario
    if cannot? :update, ConvenioDeGestionSumar
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que la petición contenga los parámetros esperados
    if !params[:convenio_de_gestion_sumar]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Guardar las prestaciones seleccionadas para luego rellenar la tabla asociada si se graba correctamente
    @prestacion_autorizada_ids = params[:convenio_de_gestion_sumar].delete(:prestacion_autorizada_ids).reject(&:blank?) || []
    migrar_prestaciones = params[:migrar_prestaciones]

    # Obtener el convenio
    begin
      @convenio_de_gestion = ConvenioDeGestionSumar.find(params[:id], :include => [:efector, :prestaciones_autorizadas])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Actualizar los valores de los atributos para validar el registro antes de guardarlo
    @convenio_de_gestion.attributes = params[:convenio_de_gestion_sumar]

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @prestaciones =
      Prestacion.where("objeto_de_la_prestacion_id IS NOT NULL", :order => :codigo).collect{
        |p| [p.codigo + " - " + p.nombre_corto, p.id]
      }
    @firmantes = Referente.where(:efector_id => @convenio_de_gestion.efector_id).collect{ |r|
      [r.contacto.mostrado, r.id, {:class => r.efector_id}]
    }
    @firmante_id = @convenio_de_gestion.firmante_id

    # Verificar la validez del objeto
    if @convenio_de_gestion.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if ( @prestacion_autorizada_ids.any?{|p_id| !((@prestaciones.collect{|p| p[1]}).member?(p_id.to_i))} ||
           @firmante_id.present? && !@firmantes.collect{|f| f[1]}.member?(@firmante_id.to_i) )
        redirect_to(root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre este incidente."
          }
        )
        return
      end

      # Registrar el usuario que realiza la modificación
      @convenio_de_gestion.updater_id = current_user.id

# TODO: esto está mal, si se modifican datos legales, se destruye la info de las prestaciones autorizadas y se recrea, cuando esa
# información se está agregando por procesos automatizados y no por los usuarios. Además afectaría las bajas dadas por adenda, en
# caso que existieran
#      Modificar los registros dependientes
#      @convenio_de_gestion.prestaciones_autorizadas.destroy_all
#      @convenio_de_gestion.prestaciones_autorizadas.build(
#        @prestacion_autorizada_ids.collect{
#          |p| { :efector_id => @convenio_de_gestion.efector.id, :prestacion_id => p,
#            :fecha_de_inicio => @convenio_de_gestion.fecha_de_inicio
#          }
#        }
#      )

      # Guardar el convenio
      @convenio_de_gestion.save

      # Verificamos si se ha solicitado la migración de prestaciones (y que en este caso no se seleccionaran prestaciones manualmente)
      if migrar_prestaciones == "1" && @convenio_de_gestion.prestaciones_autorizadas.size == 0
        ActiveRecord::Base.connection.execute "
          INSERT INTO prestaciones_autorizadas
            (efector_id, prestacion_id, fecha_de_inicio, autorizante_al_alta_id, autorizante_al_alta_type,
            created_at, updated_at, creator_id, updater_id)
            SELECT DISTINCT ON (efector_id, prestacion_sumar_id)
              cgs.efector_id efector_id,
              prestacion_sumar_id prestacion_id,
              cgs.fecha_de_inicio fecha_de_inicio,
              cgs.id autorizante_al_alta_id,
              'ConvenioDeGestionSumar'::text autorizante_al_alta_type,
              now()::date created_at,
              now()::date updated_at,
              '1'::integer creator_id,
              '1'::integer updater_id
              FROM
                convenios_de_gestion_sumar cgs
                JOIN efectores ef ON ef.id = cgs.efector_id
                JOIN prestaciones_autorizadas pa ON (
                  pa.efector_id = cgs.efector_id
                  AND pa.fecha_de_finalizacion = cgs.fecha_de_inicio
                )
                JOIN prestaciones_nacer_sumar pns ON pns.prestacion_nacer_id = pa.prestacion_id
                JOIN asignaciones_de_precios ap ON (
                  ap.nomenclador_id = '5'  -- TODO: Cambiar este valor fijo por una búsqueda
                  AND ap.area_de_prestacion_id = ef.area_de_prestacion_id
                  AND ap.prestacion_id = pns.prestacion_sumar_id
                )
              WHERE cgs.id IN (
                #{@convenio_de_gestion.id}
              );
        "
      end

      redirect_to(@convenio_de_gestion,
        :flash => {:tipo => :ok, :titulo => 'Las modificaciones al convenio de gestión se guardaron correctamente.' }
      )
    else
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "edit"
    end
  end

  # GET /convenios_de_gestion_sumar/:id/addendas
  def addendas
    # Verificar los permisos del usuario
    if cannot? :read, AddendaSumar
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
        ConvenioDeGestionSumar.find(params[:id],
          :include => {
            :addendas_sumar => [ {:prestaciones_autorizadas_alta => :prestacion}, {:prestaciones_autorizadas_baja => :prestacion} ]
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
