# -*- encoding : utf-8 -*-
class ConveniosDeAdministracionSumarController < ApplicationController
  include ActionView::Helpers::NumberHelper

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

    respond_to do |format|
      format.odt do
        convenio_de_gestion = @convenio_de_administracion.efector.convenio_de_gestion_sumar
        if !convenio_de_gestion.present?
          redirect_to(@convenio_de_administracion,
            :flash => { :tipo => :error, :titulo => "Falta el convenio de gestión",
              :mensaje => "Debe cargar el compromiso de gestión correspondiente para poder generar el documento."
            }
          )
          return
        end

        report = ODFReport::Report.new("lib/tasks/datos/plantillas/Modelo de compromiso de administración.odt") do |r|
          r.add_field :cas_sumar_numero, @convenio_de_administracion.numero
          r.add_field(
            :cgs_fecha_de_suscripcion,
            I18n::l(convenio_de_gestion.fecha_de_suscripcion, :format => :long)
          )
          if @convenio_de_administracion.efector.grupo_de_efectores.tipo_de_efector == "PSB"
            r.add_field :efector_articulo, "la"
            r.add_field :efector_o_a, "a"
          else
            r.add_field :efector_articulo, "el"
            r.add_field :efector_o_a, "o"
          end
          r.add_field :efector_nombre, @convenio_de_administracion.efector.nombre
          if @convenio_de_administracion.administrador.grupo_de_efectores.tipo_de_efector == "ADM"
            r.add_field :administrador_articulo, "la"
            r.add_field :administrador_o_a, "a"
          else
            r.add_field :administrador_articulo, "el"
            r.add_field :administrador_o_a, "o"
          end
          r.add_field :administrador_nombre, @convenio_de_administracion.administrador.nombre
          if !@convenio_de_administracion.administrador.domicilio.blank?
            r.add_field :administrador_domicilio, @convenio_de_administracion.administrador.domicilio.to_s.strip.gsub(".", ",")
          end
          if @convenio_de_administracion.firmante.present?
            if @convenio_de_administracion.firmante.contacto.sexo.present?
              if @convenio_de_administracion.firmante.contacto.sexo.codigo == "F"
                r.add_field :administrador_contacto_articulo, "la"
              else
                r.add_field :administrador_contacto_articulo, "el"
              end
            end
            r.add_field :administrador_mostrado, @convenio_de_administracion.firmante.contacto.mostrado
            if @convenio_de_administracion.firmante.contacto.tipo_de_documento.present?
              r.add_field :administrador_tipo_de_documento, @convenio_de_administracion.firmante.contacto.tipo_de_documento.codigo
            end
            if !@convenio_de_administracion.firmante.contacto.dni.blank?
              r.add_field(
                :administrador_dni,
                number_with_delimiter(@convenio_de_administracion.firmante.contacto.dni, {:delimiter => "."})
              )
            end
            if !@convenio_de_administracion.firmante.contacto.firma_primera_linea.blank?
              r.add_field(
                :administrador_firma_primera_linea,
                @convenio_de_administracion.firmante.contacto.firma_primera_linea.strip
              )
            end
            if !@convenio_de_administracion.firmante.contacto.firma_segunda_linea.blank?
              r.add_field(
                :administrador_firma_segunda_linea,
                @convenio_de_administracion.firmante.contacto.firma_segunda_linea.strip
              )
            end
            if !@convenio_de_administracion.firmante.contacto.firma_tercera_linea.blank?
              r.add_field(
                :administrador_firma_tercera_linea,
                @convenio_de_administracion.firmante.contacto.firma_tercera_linea.strip
              )
            end
          end
          if convenio_de_gestion.firmante.present?
            r.add_field :efector_mostrado, convenio_de_gestion.firmante.contacto.mostrado
            if convenio_de_gestion.firmante.contacto.tipo_de_documento.present?
              r.add_field(
                :efector_tipo_de_documento,
                convenio_de_gestion.firmante.contacto.tipo_de_documento.codigo
              )
            end
            if !convenio_de_gestion.firmante.contacto.dni.blank?
              r.add_field(
                :efector_dni,
                number_with_delimiter(convenio_de_gestion.firmante.contacto.dni, {:delimiter => "."})
              )
            end
            if !convenio_de_gestion.firmante.contacto.firma_primera_linea.blank?
              r.add_field :efector_firma_primera_linea, convenio_de_gestion.firmante.contacto.firma_primera_linea.strip
            end
            if !convenio_de_gestion.firmante.contacto.firma_segunda_linea.blank?
              r.add_field :efector_firma_segunda_linea, convenio_de_gestion.firmante.contacto.firma_segunda_linea.strip
            end
            if !convenio_de_gestion.firmante.contacto.firma_tercera_linea.blank?
              r.add_field :efector_firma_tercera_linea, convenio_de_gestion.firmante.contacto.firma_tercera_linea.strip
            end
          end
          if !@convenio_de_administracion.efector.domicilio.blank?
            r.add_field :efector_domicilio, @convenio_de_administracion.efector.domicilio.to_s.strip.gsub(".", ",")
          end
          if !convenio_de_gestion.email.blank?
            r.add_field :cgs_correo_electronico, convenio_de_gestion.email.strip
          end
          if !@convenio_de_administracion.efector.telefonos.blank?
            r.add_field :efector_fax, @convenio_de_administracion.efector.telefonos.strip
          end
          if !@convenio_de_administracion.efector.codigo_postal.blank?
            r.add_field :efector_codigo_postal, @convenio_de_administracion.efector.codigo_postal.strip
          end
          if !@convenio_de_administracion.email.blank?
            r.add_field :cas_correo_electronico, @convenio_de_administracion.email.strip
          end
          if !@convenio_de_administracion.administrador.telefonos.blank?
            r.add_field :administrador_fax, @convenio_de_administracion.administrador.telefonos.strip
          end
          if !@convenio_de_administracion.administrador.codigo_postal.blank?
            r.add_field :administrador_codigo_postal, @convenio_de_administracion.administrador.codigo_postal.strip
          end
          if !@convenio_de_administracion.administrador.numero_de_cuenta_principal.blank?
            r.add_field :administrador_cuenta_principal, @convenio_de_administracion.administrador.numero_de_cuenta_principal.strip
          end
          if !@convenio_de_administracion.administrador.denominacion_cuenta_principal.blank?
            r.add_field :administrador_denominacion_principal, @convenio_de_administracion.administrador.denominacion_cuenta_principal.strip
          end
          if !@convenio_de_administracion.administrador.banco_cuenta_principal.blank?
            r.add_field :administrador_banco_principal, @convenio_de_administracion.administrador.banco_cuenta_principal.strip
          end
          if !@convenio_de_administracion.administrador.sucursal_cuenta_principal.blank?
            r.add_field :administrador_sucursal_principal, @convenio_de_administracion.administrador.sucursal_cuenta_principal.strip
          end
          if !@convenio_de_administracion.administrador.numero_de_cuenta_secundaria.blank?
            otra_cuenta =
              " y de la cuenta bancaria Nº " + \
              @convenio_de_administracion.administrador.numero_de_cuenta_secundaria.strip + " “" + \
              @convenio_de_administracion.administrador.denominacion_cuenta_secundaria.to_s.strip + "” abierta en la entidad " + \
              @convenio_de_administracion.administrador.banco_cuenta_secundaria.to_s.strip + ", sucursal " + \
              @convenio_de_administracion.administrador.sucursal_cuenta_secundaria.to_s.strip
            r.add_field :otra_cuenta, otra_cuenta
          else
            r.add_field :otra_cuenta, ""
          end
          r.add_field :cas_suscripcion_mes_y_anio, I18n.l(@convenio_de_administracion.fecha_de_suscripcion, :format => :month_and_year)
        end

        archivo = report.generate("lib/tasks/datos/documentos/Compromiso de administración - #{@convenio_de_administracion.efector.nombre}.odt")
        File.chmod(0644, "lib/tasks/datos/documentos/Compromiso de administración - #{@convenio_de_administracion.efector.nombre}.odt")

        send_file(archivo)
      end

      format.html do
      end
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
