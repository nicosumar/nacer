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
      @unidades_de_alta_de_datos =
        UnidadDeAltaDeDatos.paginate(
          :page => params[:page], :per_page => 20, :order => "updated_at DESC"
        )
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

    # Obtener el convenio
    begin
      @unidad_de_alta_de_datos = UnidadDeAltaDeDatos.find(params[:id], :include => [:centros_de_inscripcion])
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

    # Guardar los centros de inscripcion seleccionados para luego rellenar la tabla asociada si se graba correctamente
    @centro_de_inscripcion_ids = params[:unidad_de_alta_de_datos].delete(:centro_de_inscripcion_ids) || []

    # Crear una nueva unidad desde los parámetros
    @unidad_de_alta_de_datos = UnidadDeAltaDeDatos.new(params[:unidad_de_alta_de_datos])

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @centros_de_inscripcion =
      CentroDeInscripcion.find(:all, :order => :nombre).collect{ |c| [c.codigo + " - " + c.nombre_corto, c.id]}

    # Verificar la validez del objeto
    if @unidad_de_alta_de_datos.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if ( @centro_de_inscripcion_ids.any?{ |c_id| !((@centros_de_inscripcion.collect{ |c| c[1]}).member?(c_id.to_i))} )
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

      # Guardar la nueva unidad de alta de datos
      @unidad_de_alta_de_datos.save

      # Asociar los centros de inscripción seleccionados si la UAD tiene habilitada la inscripción
      if @unidad_de_alta_de_datos.inscripcion
        @unidad_de_alta_de_datos.centros_de_inscripcion = (CentroDeInscripcion.find(@centro_de_inscripcion_ids) || [])
      else
        @unidad_de_alta_de_datos.centros_de_inscripcion = []
      end

      redirect_to(@unidad_de_alta_de_datos,
        :flash => { :tipo => :ok, :titulo => 'La unidad de alta de datos se creó correctamente.',
          :mensaje => "Deberá crear la unidad de alta de datos en el sistema de gestión del padrón," +
                      "utilizando el siguiente comando SQL: INSERT INTO SMIuads () VALUES ();" +
                      "antes de poder procesar los archivos generados por esta UAD."
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
    @centro_de_inscripcion_ids = params[:unidad_de_alta_de_datos].delete(:centro_de_inscripcion_ids) || []

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

    # Verificar la validez del objeto
    if @unidad_de_alta_de_datos.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if ( @centro_de_inscripcion_ids.any?{ |c_id| !((@centros_de_inscripcion.collect{ |c| c[1]}).member?(c_id.to_i))} )
        redirect_to(root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre este incidente."
          }
        )
        return
      end

      # Registrar el usuario que realiza la modificación
      @unidad_de_alta_de_datos.updater_id = current_user.id

      # Modificar la asignación de los centros de inscripción seleccionados
      if @centro_de_inscripcion_ids.any?
        @unidad_de_alta_de_datos.centros_de_inscripcion = CentroDeInscripcion.find(@centro_de_inscripcion_ids)
      end

      # Guardar el convenio
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
