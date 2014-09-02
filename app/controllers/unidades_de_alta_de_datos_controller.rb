# -*- encoding : utf-8 -*-
class UnidadesDeAltaDeDatosController < ApplicationController
  before_filter :authenticate_user!

  # GET /unidades_de_alta_de_datos
  def index
    # Verificar los permisos del usuario
    if cannot? :read, UnidadDeAltaDeDatos
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el listado de convenios
      @unidades_de_alta_de_datos = UnidadDeAltaDeDatos.find(:all, :order => :codigo)
  end

  # GET /unidades_de_alta_de_datos/:id
  def show
    # Verificar los permisos del usuario
    if cannot? :read, UnidadDeAltaDeDatos
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener la unidad de alta de datos
    begin
      @unidad_de_alta_de_datos =
        UnidadDeAltaDeDatos.find(params[:id], :include => [:centros_de_inscripcion, :users])
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
  end

  # GET /unidades_de_alta_de_datos/new
  def new
    # Verificar los permisos del usuario
    if cannot? :create, UnidadDeAltaDeDatos
      redirect_to(root_url,
        :flash => {:tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear los objetos necesarios para la vista
    @unidad_de_alta_de_datos = UnidadDeAltaDeDatos.new
    @centros_de_inscripcion =
      CentroDeInscripcion.find(:all, :order => :nombre).collect{ |c| [c.codigo + " - " + c.nombre_corto, c.id]}
    @centro_de_inscripcion_ids = []
    @efectores =
      Efector.where("
        integrante AND NOT EXISTS (
          SELECT * FROM unidades_de_alta_de_datos WHERE efector_id = efectores.id
        )"
      ).order(:nombre).collect{ |e| [e.cuie.to_s + " - " + e.nombre_corto, e.id]}
    @efectores_facturacion =
      Efector.where(:integrante => true, :unidad_de_alta_de_datos_id => nil).order(:nombre).collect{ |e| [e.cuie.to_s + " - " + e.nombre_corto, e.id]}
    @efector_ids = []
  end

  # GET /unidades_de_alta_de_datos/:id/edit
  def edit
    # Verificar los permisos del usuario
    if cannot? :update, UnidadDeAltaDeDatos
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener la unidad de alta de datos
    begin
      @unidad_de_alta_de_datos = UnidadDeAltaDeDatos.find(params[:id], :include => [:centros_de_inscripcion, :efectores])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear los objetos necesarios para generar la vista
    @centros_de_inscripcion =
      CentroDeInscripcion.find(:all, :order => :nombre).collect{ |c| [c.codigo + " - " + c.nombre_corto, c.id]}
    @centro_de_inscripcion_ids = @unidad_de_alta_de_datos.centros_de_inscripcion.collect{ |c| c.id }
    @efector_ids = @unidad_de_alta_de_datos.efectores.collect{ |e| e.id }
    @efectores_facturacion =
      Efector.where("
        id IN (#{@efector_ids.size == 0 ? "NULL" : @efector_ids.join(",")})
        OR integrante AND unidad_de_alta_de_datos_id IS NULL
      ").order(:nombre).collect{ |e| [e.cuie.to_s + " - " + e.nombre_corto, e.id]}
    @efectores =
      Efector.where("
        integrante AND NOT EXISTS (
          SELECT * FROM unidades_de_alta_de_datos WHERE efector_id = efectores.id
        )" +
        (@unidad_de_alta_de_datos.efector_id.present? ? " OR efectores.id = '#{@unidad_de_alta_de_datos.efector_id}'" : "")
      ).order(:nombre).collect{ |e| [e.cuie.to_s + " - " + e.nombre_corto, e.id]}
  end

  # POST /unidades_de_alta_de_datos
  def create
    # Verificar los permisos del usuario
    if cannot? :create, UnidadDeAltaDeDatos
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que la petición contenga los parámetros esperados
    if !params[:unidad_de_alta_de_datos]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Guardar los centros de inscripcion y efectores seleccionados para luego rellenar la tabla asociada si se graba correctamente
    @centro_de_inscripcion_ids = params[:unidad_de_alta_de_datos].delete(:centro_de_inscripcion_ids).reject(&:blank?) || []
    @efector_ids = params[:unidad_de_alta_de_datos].delete(:efector_ids).reject(&:blank?) || []

    # Crear una nueva unidad desde los parámetros
    @unidad_de_alta_de_datos = UnidadDeAltaDeDatos.new(params[:unidad_de_alta_de_datos])

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @centros_de_inscripcion =
      CentroDeInscripcion.find(:all, :order => :nombre).collect{ |c| [c.codigo + " - " + c.nombre_corto, c.id]}
    @efectores =
      Efector.where("
        integrante AND NOT EXISTS (
          SELECT * FROM unidades_de_alta_de_datos WHERE efector_id = efectores.id
        )"
      ).order(:nombre).collect{ |e| [e.cuie.to_s + " - " + e.nombre_corto, e.id]}
    @efectores_facturacion =
      Efector.where(:integrante => true, :unidad_de_alta_de_datos_id => nil).order(:nombre).collect{ |e| [e.cuie.to_s + " - " + e.nombre_corto, e.id]}

    # Verificar la validez del objeto
    if @unidad_de_alta_de_datos.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if ( @centro_de_inscripcion_ids.any?{ |c_id| !((@centros_de_inscripcion.collect{ |c| c[1]}).member?(c_id.to_i))} ||
           @efector_ids.any?{ |e_id| !((@efectores_facturacion.collect{ |e| e[1]}).member?(e_id.to_i))} ||
           @unidad_de_alta_de_datos.efector_id.present? && !(@efectores.collect{|e| e[1]}).member?(@unidad_de_alta_de_datos.efector_id) )
        redirect_to(root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre este incidente."
          }
        )
        return
      end

      # Registrar el usuario que realiza la creación
      @unidad_de_alta_de_datos.creator_id = current_user.id
      @unidad_de_alta_de_datos.updater_id = current_user.id

      # Añadir una observación para recordar el comando que debe ejecutarse en el sistema de gestión
      @unidad_de_alta_de_datos.observaciones +=
        "\n\n-- Comando requerido para ejecutar en el sistema de gestión del padrón:\n" +
        "INSERT INTO SMIUADs\n" +
        "  (CodigoUAD, NombreUAD, CodigoProvincia, Localidad, PersonaResponsable, Telefono)\n" +
        "  VALUES ('#{@unidad_de_alta_de_datos.codigo}', '#{@unidad_de_alta_de_datos.nombre[0..49].to_s}', " +
        "'#{('%02d' % Parametro.valor_del_parametro(:id_de_esta_provincia))}', '<localidad>', " +
        "'<persona responsable>', '<teléfono>');"

      # Guardar la nueva unidad de alta de datos
      @unidad_de_alta_de_datos.save

      # Asociar los centros de inscripción seleccionados si la UAD tiene habilitada la inscripción
      if @unidad_de_alta_de_datos.inscripcion
        @unidad_de_alta_de_datos.centros_de_inscripcion = (CentroDeInscripcion.find(@centro_de_inscripcion_ids) || [])
      else
        @unidad_de_alta_de_datos.centros_de_inscripcion = []
      end

      # Asociar los efectores seleccionados si la UAD tiene habilitada la facturación
      if @unidad_de_alta_de_datos.facturacion
        @unidad_de_alta_de_datos.efectores = (Efector.find(@efector_ids) || [])
      else
        @unidad_de_alta_de_datos.efectores = []
      end

      redirect_to(@unidad_de_alta_de_datos,
        :flash => { :tipo => :ok, :titulo => 'La unidad de alta de datos se creó correctamente.',
          :mensaje => "Deberá crear la unidad de alta de datos en el sistema de gestión del padrón, " +
                      "utilizando el siguiente comando SQL: INSERT INTO SMIUADs (CodigoUAD, NombreUAD, CodigoProvincia, " +
                      "Localidad, PersonaResponsable, Telefono) VALUES ('#{@unidad_de_alta_de_datos.codigo}', " +
                      "'#{@unidad_de_alta_de_datos.nombre[0..49].to_s}', " +
                      "'#{('%02d' % Parametro.valor_del_parametro(:id_de_esta_provincia))}', '<localidad>', " +
                      "'<responsable>', '<telefono>'); -- antes de poder procesar los archivos generados por esta UAD."
        }
      )
    else
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "new"
    end
  end

  # PUT /unidades_de_alta_de_datos/:id
  def update
    # Verificar los permisos del usuario
    if cannot? :update, UnidadDeAltaDeDatos
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que la petición contenga los parámetros esperados
    if !params[:unidad_de_alta_de_datos]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Guardar los centros de inscripción seleccionados para luego rellenar la tabla asociada si se graba correctamente
    @centro_de_inscripcion_ids = params[:unidad_de_alta_de_datos].delete(:centro_de_inscripcion_ids).reject(&:blank?) || []
    @efector_ids = params[:unidad_de_alta_de_datos].delete(:efector_ids).reject(&:blank?) || []

    # Obtener la unidad
    begin
      @unidad_de_alta_de_datos = UnidadDeAltaDeDatos.find(params[:id], :include => :centros_de_inscripcion)
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Actualizar los valores de los atributos para validar el registro antes de guardarlo
    @unidad_de_alta_de_datos.attributes = params[:unidad_de_alta_de_datos]

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @centros_de_inscripcion =
      CentroDeInscripcion.find(:all, :order => :nombre).collect{ |c| [c.codigo + " - " + c.nombre_corto, c.id]}
    @efectores =
      Efector.where("
        integrante AND NOT EXISTS (
          SELECT * FROM unidades_de_alta_de_datos WHERE efector_id = efectores.id
        )" +
        (@unidad_de_alta_de_datos.efector_id.present? ? " OR efectores.id = '#{@unidad_de_alta_de_datos.efector_id}'" : "")
      ).order(:nombre).collect{ |e| [e.cuie.to_s + " - " + e.nombre_corto, e.id]}
    @efectores_facturacion =
      Efector.where("
        id IN (#{@unidad_de_alta_de_datos.efectores.size == 0 ? "NULL" : @unidad_de_alta_de_datos.efectores.collect{ |e| e.id }.join(",")})
        OR integrante AND unidad_de_alta_de_datos_id IS NULL
      ").order(:nombre).collect{ |e| [e.cuie.to_s + " - " + e.nombre_corto, e.id]}

    # Verificar la validez del objeto
    if @unidad_de_alta_de_datos.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if ( @centro_de_inscripcion_ids.any?{ |c_id| !((@centros_de_inscripcion.collect{ |c| c[1]}).member?(c_id.to_i))} ||
           @efector_ids.any?{ |e_id| !((@efectores_facturacion.collect{ |e| e[1]}).member?(e_id.to_i))} ||
           @unidad_de_alta_de_datos.efector_id.present? && !(@efectores.collect{|e| e[1]}).member?(@unidad_de_alta_de_datos.efector_id) )
        redirect_to(root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre este incidente."
          }
        )
        return
      end

      # Registrar el usuario que realiza la modificación
      @unidad_de_alta_de_datos.updater_id = current_user.id

      # Modificar la asociación de centros de inscripción seleccionados si la UAD tiene habilitada la inscripción
      if @unidad_de_alta_de_datos.inscripcion
        @unidad_de_alta_de_datos.centros_de_inscripcion = (CentroDeInscripcion.find(@centro_de_inscripcion_ids) || [])
      else
        @unidad_de_alta_de_datos.centros_de_inscripcion = []
      end

      # Modificar la asociación de los efectores seleccionados si la UAD tiene habilitada la facturación
      if @unidad_de_alta_de_datos.facturacion
        @unidad_de_alta_de_datos.efectores = (Efector.find(@efector_ids) || [])
      else
        @unidad_de_alta_de_datos.efectores = []
      end

      # Guardar la unidad de alta de datos
      @unidad_de_alta_de_datos.save
      redirect_to(@unidad_de_alta_de_datos,
        :flash => {:tipo => :ok, :titulo => 'Las modificaciones a la unidad de alta de datos se guardaron correctamente.' }
      )
    else
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "edit"
    end
  end

end
