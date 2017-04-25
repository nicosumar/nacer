# -*- encoding : utf-8 -*-
class NovedadesDeLosAfiliadosController < ApplicationController
  before_filter :authenticate_user!

  # GET /novedades_de_los_afiliados
  def index
    # Verificar los permisos del usuario
    if cannot? :read, NovedadDelAfiliado
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Preparar los objetos necesarios para la vista
    @estados_de_las_novedades =
      [["En cualquier estado", nil]] +
      EstadoDeLaNovedad.find(:all, :order => :id).collect{ |e| ["En estado '" + e.nombre + "'", e.id] }

    # Verificar si hay un parámetro para filtrar las novedades
    if params[:estado_de_la_novedad_id].blank?
      # No hay filtro, devolver todas las novedades registradas
      @novedades =
        NovedadDelAfiliado.paginate( :page => params[:page], :per_page => 20, :include => :tipo_de_novedad,
          :order => "updated_at DESC"
        )
      @estado_de_la_novedad_id = nil
      @descripcion_del_estado = 'registradas'
    else
      @estado_de_la_novedad_id = params[:estado_de_la_novedad_id].to_i
      # Verificar que el parámetro sea un estado válido
      if @estado_de_la_novedad_id && !@estados_de_las_novedades.collect{|i| i[1]}.member?(@estado_de_la_novedad_id)
        redirect_to(root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
           :mensaje => "Se informará al administrador del sistema sobre este incidente."
          }
        )
        return
      end
      @descripcion_del_estado = EstadoDeLaNovedad.find(@estado_de_la_novedad_id).nombre

      # Obtener las novedades filtradas de acuerdo con el parámetro
      @novedades =
        NovedadDelAfiliado.con_estado(@estado_de_la_novedad_id).paginate(:page => params[:page], :per_page => 20, :include => :tipo_de_novedad,
          :order => "updated_at DESC"
        )
    end

  end

  # GET /novedades_de_los_afiliados/:id
  def show
    # Verificar los permisos del usuario
    if cannot? :read, NovedadDelAfiliado
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Buscar la novedad
    begin
      @novedad =
        NovedadDelAfiliado.find( params[:id],
          :include => [ :estado_de_la_novedad, :clase_de_documento, :tipo_de_documento, :sexo, :pais_de_nacimiento,
            :lengua_originaria, :tribu_originaria, :alfabetizacion_del_beneficiario, :domicilio_departamento, :domicilio_distrito,
            :lugar_de_atencion_habitual, :tipo_de_documento_de_la_madre, :alfabetizacion_de_la_madre, :tipo_de_documento_del_padre,
            :alfabetizacion_del_padre, :tipo_de_documento_del_tutor, :alfabetizacion_del_tutor, :discapacidad,
            :centro_de_inscripcion
          ]
        )
      if @novedad.tipo_de_novedad.codigo == "M"
        @afiliado =
          Afiliado.find_by_clave_de_beneficiario( @novedad.clave_de_beneficiario,
            :include => [ :clase_de_documento, :tipo_de_documento, :sexo, :pais_de_nacimiento, :lengua_originaria,
              :tribu_originaria, :alfabetizacion_del_beneficiario, :domicilio_departamento, :domicilio_distrito,
              :lugar_de_atencion_habitual, :tipo_de_documento_de_la_madre, :alfabetizacion_de_la_madre,
              :tipo_de_documento_del_padre, :alfabetizacion_del_padre, :tipo_de_documento_del_tutor, :alfabetizacion_del_tutor,
              :discapacidad
            ]
          )
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Generar las advertencias si la novedad está incompleta
    if @novedad.estado_de_la_novedad.codigo == "I"
      @novedad.generar_advertencias
    end
  end

  # GET /novedades_de_los_afiliados/new_alta
  def new_alta
    # Verificar los permisos del usuario
    if cannot? :create, NovedadDelAfiliado
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."})
      return
    end

    # Crear objetos comunes para generar los formularios
    @clases_de_documentos = ClaseDeDocumento.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @tipos_de_documentos = TipoDeDocumento.where(:activo => true).collect{ |i| [i.nombre, i.id]}

    # Esta acción se ejecuta dos veces. Una verificación previa, y si pasa las verificaciones, la creación de la nueva solicitud de alta
    if !params[:novedad_del_afiliado]
      # Crear objeto vacío para generar el formulario
      @novedad = NovedadDelAfiliado.new()
      @novedad.tipo_de_novedad_id = TipoDeNovedad.id_del_codigo("A")
      @novedad.clase_de_documento_id = ClaseDeDocumento.id_del_codigo("P")
      @novedad.tipo_de_documento_id = TipoDeDocumento.id_del_codigo("DNI")
      render :action => "verificacion"
      return
    else
      # Crear una nueva novedad desde los parámetros
      @novedad = NovedadDelAfiliado.new(params[:novedad_del_afiliado])
      @novedad.tipo_de_novedad_id = TipoDeNovedad.id_del_codigo("A")
      @novedad.apellido = @novedad.apellido.mb_chars.upcase.to_s
      @novedad.nombre = @novedad.nombre.mb_chars.upcase.to_s

      if !@novedad.verificacion_correcta?
        # Volver a presentar el formulario si hay errores de verificación
        render :action => "verificacion"
        return
      end
    end

    # Asignar valores a los atributos de la novedad
    @novedad.tipo_de_novedad_id = TipoDeNovedad.id_del_codigo("A")

    # Crear objetos para rellenar las colecciones de las listas de selección
    @sexos = Sexo.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @paises = Pais.ordenados_por_frecuencia(:novedades_de_los_afiliados, :pais_de_nacimiento_id).collect{ |i| [i.nombre, i.id]}
    @lenguas_originarias =
      LenguaOriginaria.ordenados_por_frecuencia(:novedades_de_los_afiliados, :lengua_originaria_id).collect{ |i| [i.nombre, i.id] }
    @tribus_originarias =
      TribuOriginaria.ordenados_por_frecuencia(:novedades_de_los_afiliados, :tribu_originaria_id).collect{ |i| [i.nombre, i.id] }
    @niveles_de_instruccion = NivelDeInstruccion.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @departamentos = Departamento.ordenados_por_frecuencia(:novedades_de_los_afiliados, :domicilio_departamento_id).collect{
      |i| [i.nombre, i.id]
    }
    @distritos = Distrito.ordenados_por_frecuencia(:novedades_de_los_afiliados, :domicilio_distrito_id,
      @novedad.domicilio_departamento_id).collect{ |i| [i.nombre, i.id] }
    @codigos_postales = Distrito.find(:all).collect{ |i| {:distrito_id => i.id, :codigo_postal => i.codigo_postal}}
    @efectores = Efector.find(:all).collect{ |i| [i.nombre, i.id] }.sort
    @discapacidades = Discapacidad.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @centros_de_inscripcion =
      UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual]).centros_de_inscripcion.collect{ |i| [i.nombre, i.id]}.sort
    @post_form_url = create_alta_novedades_de_los_afiliados_url

    render :action => "new"
  end

  # GET /novedades_de_los_afiliados/new_modificacion
  def new_modificacion
    # Verificar los permisos del usuario
    if cannot? :create, NovedadDelAfiliado
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."})
      return
    end

    # Verificar que se haya pasado el ID del afiliado que se modificará
    if !params[:afiliado_id]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Buscar el afiliado
    begin
      @afiliado = Afiliado.find(params[:afiliado_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que este afiliado no tenga una novedad pendiente
    if @afiliado.novedad_pendiente?
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear el objeto requerido para generar el formulario
    @novedad = NovedadDelAfiliado.new

    # Asignar valores a los atributos de la novedad
    @novedad.tipo_de_novedad_id = TipoDeNovedad.id_del_codigo("M")
    @novedad.copiar_atributos_del_afiliado(@afiliado)

    # Crear objetos para rellenar las colecciones de las listas de selección
    @clases_de_documentos = ClaseDeDocumento.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @tipos_de_documentos = TipoDeDocumento.where(:activo => true).collect{ |i| [i.nombre, i.id]}
    @sexos = Sexo.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @paises = Pais.ordenados_por_frecuencia(:novedades_de_los_afiliados, :pais_de_nacimiento_id).collect{ |i| [i.nombre, i.id]}
    @lenguas_originarias =
      LenguaOriginaria.ordenados_por_frecuencia(:novedades_de_los_afiliados, :lengua_originaria_id).collect{ |i| [i.nombre, i.id] }
    @tribus_originarias =
      TribuOriginaria.ordenados_por_frecuencia(:novedades_de_los_afiliados, :tribu_originaria_id).collect{ |i| [i.nombre, i.id] }
    @niveles_de_instruccion = NivelDeInstruccion.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @departamentos = Departamento.ordenados_por_frecuencia(:novedades_de_los_afiliados, :domicilio_departamento_id).collect{
      |i| [i.nombre, i.id]
    }
    @distritos = Distrito.ordenados_por_frecuencia(:novedades_de_los_afiliados, :domicilio_distrito_id,
      @novedad.domicilio_departamento_id).collect{ |i| [i.nombre, i.id] }
    @codigos_postales = Distrito.find(:all).collect{ |i| {:distrito_id => i.id, :codigo_postal => i.codigo_postal}}
    @efectores = Efector.find(:all).collect{ |i| [i.nombre, i.id] }.sort
    @discapacidades = Discapacidad.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @centros_de_inscripcion =
      UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual]).centros_de_inscripcion.collect{ |i| [i.nombre, i.id]}.sort
    @post_form_url = create_modificacion_novedades_de_los_afiliados_url

    render :action => "new"
  end

  # GET /novedades_de_los_afiliados/new_baja
  def new_baja
    # Verificar los permisos del usuario
    if cannot? :create, NovedadDelAfiliado
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."})
      return
    end

    # Verificar que se haya pasado el ID del afiliado que se modificará
    if !params[:afiliado_id]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Buscar el afiliado
    begin
      @afiliado = Afiliado.find(params[:afiliado_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que este afiliado no tenga una novedad pendiente
    if @afiliado.novedad_pendiente?
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear el objeto requerido para generar el formulario
    @novedad = NovedadDelAfiliado.new

    # Asignar valores a los atributos de la novedad
    @novedad.copiar_atributos_del_afiliado(@afiliado)
    @novedad.tipo_de_novedad_id = TipoDeNovedad.id_del_codigo("B")
    @novedad.fecha_de_la_novedad = Date.today

    # Crear objetos requeridos para la vista
    @centros_de_inscripcion =
      UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual]).centros_de_inscripcion.collect{ |i| [i.nombre, i.id]}.sort
    @motivos_bajas_beneficiarios = 
      MotivoBajaBeneficiario.all.collect{ |i| [i.nombre, i.id]}.sort
    @post_form_url = create_baja_novedades_de_los_afiliados_url

    render :action => "new"
  end

  # GET /novedades_de_los_afiliados/:id/edit
  def edit
    # Verificar los permisos del usuario
    if cannot? :update, NovedadDelAfiliado
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Buscar la novedad
    begin
      @novedad = NovedadDelAfiliado.find(params[:id])
      # Verificar que la novedad esté pendiente
      if !@novedad.pendiente?
        redirect_to( root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre este incidente."
          }
        )
        return
      end
      # Buscar el afiliado asociado a esta novedad si es una modificación de datos
      if @novedad.tipo_de_novedad.codigo != "A"
        @afiliado = Afiliado.find_by_clave_de_beneficiario(@novedad.clave_de_beneficiario)
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear objetos para rellenar las colecciones de las listas de selección
    @clases_de_documentos = ClaseDeDocumento.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @tipos_de_documentos = TipoDeDocumento.where(:activo => true).collect{ |i| [i.nombre, i.id]}
    @sexos = Sexo.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @paises = Pais.ordenados_por_frecuencia(:novedades_de_los_afiliados,
      :pais_de_nacimiento_id).collect{ |i| [i.nombre, i.id]}
    @lenguas_originarias = LenguaOriginaria.ordenados_por_frecuencia(:novedades_de_los_afiliados,
      :lengua_originaria_id).collect{ |i| [i.nombre, i.id]}
    @tribus_originarias = TribuOriginaria.ordenados_por_frecuencia(:novedades_de_los_afiliados,
      :tribu_originaria_id).collect{ |i| [i.nombre, i.id]}
    @niveles_de_instruccion = NivelDeInstruccion.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @departamentos = Departamento.ordenados_por_frecuencia(:novedades_de_los_afiliados,
      :domicilio_departamento_id).collect{ |i| [i.nombre, i.id]}
    @distritos = Distrito.ordenados_por_frecuencia(:novedades_de_los_afiliados,
      :domicilio_distrito_id, @novedad.domicilio_departamento_id).collect{ |i| [i.nombre, i.id]}
    @codigos_postales = Distrito.find(:all).collect{ |i| {:distrito_id => i.id,
      :codigo_postal => i.codigo_postal}}
    @efectores = Efector.find(:all).collect{ |i| [i.nombre, i.id] }.sort
    @discapacidades = Discapacidad.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @centros_de_inscripcion =
      UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual]).centros_de_inscripcion.collect{ |i| [i.nombre, i.id]}.sort

  end

  # POST /novedades_de_los_afiliados/alta
  def create_alta
    create(:alta)
  end

  # POST /novedades_de_los_afiliados/baja
  def create_baja
    # Verificar que se haya pasado el ID del afiliado para el que se solicita la baja
    if !params[:afiliado_id]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Buscar el afiliado
    begin
      @afiliado = Afiliado.find(params[:afiliado_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Creamos una nueva novedad y copiamos los datos del afiliado
    @novedad = NovedadDelAfiliado.new
    @novedad.copiar_atributos_del_afiliado(@afiliado)

    # Actualizar el resto de los atributos
    @novedad.attributes = params[:novedad_del_afiliado]
    @novedad.tipo_de_novedad_id = TipoDeNovedad.id_del_codigo("B")
    @novedad.fecha_de_la_novedad = Date.today
    @novedad.categoria_de_afiliado_id = @novedad.categorizar
    @novedad.clave_de_beneficiario = @afiliado.clave_de_beneficiario

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @centros_de_inscripcion =
      UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual]).centros_de_inscripcion.collect{ |i| [i.nombre, i.id]}.sort
    @post_form_url = create_baja_novedades_de_los_afiliados_url

    if @novedad.invalid?
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "new"
      return
    end

    if UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual]).facturacion
      # Verificar si existen prestaciones cargadas para la misma clave de beneficiario, que estén pendientes, en cuyo caso
      # no se permite dar la baja
      if PrestacionBrindada.where(:clave_de_beneficiario => @novedad.clave_de_beneficiario).any? { |pb| pb.pendiente? }
        redirect_to( @afiliado,
          :flash => { :tipo => :error, :titulo => "No se puede solicitar la baja",
            :mensaje => "No es posible solicitar la baja porque " +
              (@novedad.sexo.codigo == "F" ? "la beneficiaria" : "el beneficiario") +
              " tiene alguna prestación brindada pendiente de resolución."
          }
        )
        return
      end
    end

    # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
    if
      (
        @novedad.centro_de_inscripcion_id && !@centros_de_inscripcion.collect{
          |i| i[1] }.member?(@novedad.centro_de_inscripcion_id)
      )
      redirect_to(root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
         :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Registrar el usuario que realiza la creación
    @novedad.creator_id = current_user.id
    @novedad.updater_id = current_user.id

    # Guardar la solicitud, marcándola como pendiente de informar
    @novedad.estado_de_la_novedad_id = EstadoDeLaNovedad.id_del_codigo("R")
    @novedad.save
    redirect_to( novedad_del_afiliado_path(@novedad),
      :flash => { :tipo => :ok, :titulo => "La solicitud se guardó correctamente" }
    )
  end

  # POST /novedades_de_los_afiliados/modificacion
  def create_modificacion
    create(:modificacion)
  end

  def create(tipo)
    # Verificar los permisos del usuario
    if cannot? :create, NovedadDelAfiliado
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que la petición contenga los parámetros esperados
    if !params[:novedad_del_afiliado]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear la nueva novedad desde los parámetros, según el tipo de operación y establecer los valores que no se pueden
    # asignar masivamente
    case

      when tipo == :alta
        # Crear el objeto desde los parámetros
        @novedad = NovedadDelAfiliado.new(params[:novedad_del_afiliado])
        @novedad.tipo_de_novedad_id = TipoDeNovedad.id_del_codigo("A")
        @post_form_url = create_alta_novedades_de_los_afiliados_url

      when tipo == :modificacion
        # Verificar que se haya pasado el ID del afiliado que se modificará
        if !params[:afiliado_id]
          redirect_to( root_url,
            :flash => { :tipo => :error, :titulo => "La petición no es válida",
              :mensaje => "Se informará al administrador del sistema sobre este incidente."
            }
          )
          return
        end
        # Buscar el afiliado
        begin
          @afiliado = Afiliado.find(params[:afiliado_id])
        rescue ActiveRecord::RecordNotFound
          redirect_to( root_url,
            :flash => { :tipo => :error, :titulo => "La petición no es válida",
              :mensaje => "Se informará al administrador del sistema sobre este incidente."
            }
          )
          return
        end
        # Creamos una nueva novedad y copiamos los datos del afiliado
        @novedad = NovedadDelAfiliado.new
        @novedad.copiar_atributos_del_afiliado(@afiliado)
        @post_form_url = create_modificacion_novedades_de_los_afiliados_url

        # Actualizar el resto de los atributos con los valores pasados en los parámetros
        @novedad.attributes = params[:novedad_del_afiliado]
        @novedad.tipo_de_novedad_id = TipoDeNovedad.id_del_codigo("M")
    end

    @novedad.categoria_de_afiliado_id = @novedad.categorizar
    @novedad.apellido = @novedad.apellido.mb_chars.upcase.to_s
    @novedad.nombre = @novedad.nombre.mb_chars.upcase.to_s

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @clases_de_documentos = ClaseDeDocumento.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @tipos_de_documentos = TipoDeDocumento.where(:activo => true).collect{ |i| [i.nombre, i.id]}
    @sexos = Sexo.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @paises = Pais.ordenados_por_frecuencia(:novedades_de_los_afiliados, :pais_de_nacimiento_id).collect{ |i| [i.nombre, i.id]}
    @lenguas_originarias =
      LenguaOriginaria.ordenados_por_frecuencia(:novedades_de_los_afiliados, :lengua_originaria_id).collect{ |i| [i.nombre, i.id] }
    @tribus_originarias =
      TribuOriginaria.ordenados_por_frecuencia(:novedades_de_los_afiliados, :tribu_originaria_id).collect{ |i| [i.nombre, i.id] }
    @niveles_de_instruccion = NivelDeInstruccion.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @departamentos = Departamento.ordenados_por_frecuencia(:novedades_de_los_afiliados, :domicilio_departamento_id).collect{
      |i| [i.nombre, i.id]
    }
    @distritos = Distrito.ordenados_por_frecuencia(:novedades_de_los_afiliados,
      :domicilio_distrito_id, @novedad.domicilio_departamento_id).collect{ |i| [i.nombre, i.id]}
    @codigos_postales = Distrito.find(:all).collect{ |i| {:distrito_id => i.id, :codigo_postal => i.codigo_postal}}
    @efectores = Efector.find(:all).collect{ |i| [i.nombre, i.id] }.sort
    @discapacidades = Discapacidad.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @centros_de_inscripcion =
      UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual]).centros_de_inscripcion.collect{ |i| [i.nombre, i.id]}.sort

    # Asignarle la fecha de nacimiento a la fecha de la novedad si la inscripción corresponde a un alta de RN menor de 4 meses
    if tipo == :alta && @novedad.fecha_de_nacimiento.present? && @novedad.fecha_de_nacimiento >= (Date.today - 4.months)
      @novedad.fecha_de_la_novedad = @novedad.fecha_de_nacimiento
    end
    
    # Asignarle si es una modificacion y se saco el embarazo limpio los datos de embarazo anterior
    if tipo == :modificacion && !@novedad.esta_embarazada
      @novedad.fecha_de_la_ultima_menstruacion = ""
      @novedad.fecha_de_diagnostico_del_embarazo = ""
      @novedad.semanas_de_embarazo = ""
      @novedad.fecha_probable_de_parto = ""
      @novedad.fecha_efectiva_de_parto = ""
    end
    
    if @novedad.invalid?
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "new"
      return
    end

    # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
    if
      (
        @novedad.clase_de_documento_id && !@clases_de_documentos.collect{ |i| i[1] }.member?(@novedad.clase_de_documento_id) ||
        @novedad.tipo_de_documento_id && !@tipos_de_documentos.collect{ |i| i[1] }.member?(@novedad.tipo_de_documento_id) ||
        @novedad.sexo_id && !@sexos.collect{ |i| i[1] }.member?(@novedad.sexo_id) ||
        @novedad.pais_de_nacimiento_id && !@paises.collect{ |i| i[1] }.member?(@novedad.pais_de_nacimiento_id) ||
        @novedad.lengua_originaria_id && !@lenguas_originarias.collect{ |i| i[1] }.member?(@novedad.lengua_originaria_id) ||
        @novedad.tribu_originaria_id && !@tribus_originarias.collect{ |i| i[1] }.member?(@novedad.tribu_originaria_id) ||
        @novedad.alfabetizacion_del_beneficiario_id && !@niveles_de_instruccion.collect{
          |i| i[1] }.member?(@novedad.alfabetizacion_del_beneficiario_id) ||
        @novedad.domicilio_departamento_id && !@departamentos.collect{ |i| i[1] }.member?(@novedad.domicilio_departamento_id) ||
        @novedad.domicilio_distrito_id && !@distritos.collect{ |i| i[1] }.member?(@novedad.domicilio_distrito_id) ||
        @novedad.lugar_de_atencion_habitual_id && !@efectores.collect{
          |i| i[1] }.member?(@novedad.lugar_de_atencion_habitual_id) ||
        @novedad.tipo_de_documento_de_la_madre_id && !@tipos_de_documentos.collect{
          |i| i[1] }.member?(@novedad.tipo_de_documento_de_la_madre_id) ||
        @novedad.alfabetizacion_de_la_madre_id && !@niveles_de_instruccion.collect{
          |i| i[1] }.member?(@novedad.alfabetizacion_de_la_madre_id) ||
        @novedad.tipo_de_documento_del_padre_id && !@tipos_de_documentos.collect{
          |i| i[1] }.member?(@novedad.tipo_de_documento_del_padre_id) ||
        @novedad.alfabetizacion_del_padre_id && !@niveles_de_instruccion.collect{
          |i| i[1] }.member?(@novedad.alfabetizacion_del_padre_id) ||
        @novedad.tipo_de_documento_del_tutor_id && !@tipos_de_documentos.collect{
          |i| i[1] }.member?(@novedad.tipo_de_documento_del_tutor_id) ||
        @novedad.alfabetizacion_del_tutor_id && !@niveles_de_instruccion.collect{
          |i| i[1] }.member?(@novedad.alfabetizacion_del_tutor_id) ||
        @novedad.discapacidad_id && !@discapacidades.collect{ |i| i[1] }.member?(@novedad.discapacidad_id) ||
        @novedad.centro_de_inscripcion_id && !@centros_de_inscripcion.collect{
          |i| i[1] }.member?(@novedad.centro_de_inscripcion_id)
      )
      redirect_to(root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
         :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Generar una nueva clave de beneficiario si es un alta
    if tipo == :alta
      # Buscar el próximo número en la secuencia de generación de claves para esta UAD y CI
      codigo_ci = CentroDeInscripcion.find(@novedad.centro_de_inscripcion_id).codigo
      begin
        secuencia_siguiente =
          ActiveRecord::Base.connection.execute(
            "SELECT nextval('uad_#{session[:codigo_uad_actual]}.ci_#{codigo_ci}_clave_seq'::regclass);"
          ).values[0][0].to_i
      rescue
        redirect_to(root_url,
          :flash => { :tipo => :error, :titulo => "Error interno",
            :mensaje => "Se produjo un error al intentar generar la nueva clave de beneficiario."
          }
        )
        return
      end
      # Componer el nuevo número de clave
      @novedad.clave_de_beneficiario = ('%02d' % Parametro.valor_del_parametro(:id_de_esta_provincia)) +
        session[:codigo_uad_actual] + codigo_ci + ('%06d' % secuencia_siguiente)
    end

    # Generar mensajes de advertencia por incompletitud (si existieran)
    @novedad.generar_advertencias

    # Registrar el usuario que realiza la creación
    @novedad.creator_id = current_user.id
    @novedad.updater_id = current_user.id

    if @novedad.advertencias && @novedad.advertencias.size > 0
      # A la solicitud le faltan datos esenciales. Guardarla, pero marcándola como incompleta.
      @novedad.estado_de_la_novedad_id = EstadoDeLaNovedad.id_del_codigo("I")
      @novedad.save
      redirect_to( novedad_del_afiliado_path(@novedad),
        :flash => { :tipo => :advertencia, :titulo => "Se guardó la solicitud, pero faltan datos esenciales",
          :mensaje => @novedad.advertencias
        }
      )
    else
      # Guardar la solicitud, marcándola como pendiente de informar
      @novedad.estado_de_la_novedad_id = 2
      @novedad.save

      # TODO: analizar otros casos, ya que una modificación en una inscripción registrada podría hacer que la prestación
      # asociada ganara una advertencia, en vez de únicamente eliminarla
      if UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual]).facturacion
        # Verificar si existen prestaciones cargadas para la misma clave de beneficiario, que estén marcadas con el
        # estado 'Registrada, con advertencias', para ver si esta solicitud hizo que se eliminara la advertencia
        PrestacionBrindada.where(
          :clave_de_beneficiario => @novedad.clave_de_beneficiario,
          :estado_de_la_prestacion_id => EstadoDeLaPrestacion.id_del_codigo("F")
        ).each do |pb|
          if !pb.actualizar_metodos_de_validacion_fallados
            pb.update_attributes({:estado_de_la_prestacion_id => EstadoDeLaPrestacion.id_del_codigo("R")})
          end
        end
      end

      redirect_to( novedad_del_afiliado_path(@novedad),
        :flash => { :tipo => :ok, :titulo => "La solicitud se guardó correctamente" }
      )

    end
  end

  # PUT /novedades_de_los_afiliados/:id
  def update
    # Verificar los permisos del usuario
    if cannot? :create, NovedadDelAfiliado
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que la petición contenga los parámetros esperados
    if !params[:novedad_del_afiliado]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener la novedad
    begin
      @novedad = NovedadDelAfiliado.find(params[:id])
      if @novedad.tipo_de_novedad.codigo != "A"
        # Verificar que se haya pasado el ID del afiliado que se modificará
        if !params[:afiliado_id]
          redirect_to( root_url,
            :flash => { :tipo => :error, :titulo => "La petición no es válida",
              :mensaje => "Se informará al administrador del sistema sobre este incidente."
            }
          )
          return
        end
        # Buscar el afiliado
        @afiliado = Afiliado.find(params[:afiliado_id])
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Modificar la novedad desde los parámetros, según el tipo de operación y establecer los valores que no se pueden asignar masivamente
    @novedad.attributes = params[:novedad_del_afiliado]
    @novedad.categoria_de_afiliado_id = @novedad.categorizar
    @novedad.apellido = @novedad.apellido.mb_chars.upcase.to_s
    @novedad.nombre = @novedad.nombre.mb_chars.upcase.to_s

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @clases_de_documentos = ClaseDeDocumento.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @tipos_de_documentos = TipoDeDocumento.where(:activo => true).collect{ |i| [i.nombre, i.id]}
    @sexos = Sexo.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @paises = Pais.ordenados_por_frecuencia(:novedades_de_los_afiliados, :pais_de_nacimiento_id).collect{ |i| [i.nombre, i.id]}
    @lenguas_originarias =
      LenguaOriginaria.ordenados_por_frecuencia(:novedades_de_los_afiliados, :lengua_originaria_id).collect{ |i| [i.nombre, i.id] }
    @tribus_originarias =
      TribuOriginaria.ordenados_por_frecuencia(:novedades_de_los_afiliados, :tribu_originaria_id).collect{ |i| [i.nombre, i.id] }
    @niveles_de_instruccion = NivelDeInstruccion.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @departamentos = Departamento.ordenados_por_frecuencia(:novedades_de_los_afiliados, :domicilio_departamento_id).collect{
      |i| [i.nombre, i.id]
    }
    @distritos = Distrito.ordenados_por_frecuencia(:novedades_de_los_afiliados,
      :domicilio_distrito_id, @novedad.domicilio_departamento_id).collect{ |i| [i.nombre, i.id]}
    @codigos_postales = Distrito.find(:all).collect{ |i| {:distrito_id => i.id, :codigo_postal => i.codigo_postal}}
    @efectores = Efector.find(:all).collect{ |i| [i.nombre, i.id] }.sort
    @discapacidades = Discapacidad.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @centros_de_inscripcion =
      UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual]).centros_de_inscripcion.collect{ |i| [i.nombre, i.id]}.sort
    
    # Asignarle si es una modificacion y se saco el embarazo limpio los datos de embarazo anterior
    if !@novedad.esta_embarazada
     @novedad.fecha_de_la_ultima_menstruacion = ""
     @novedad.fecha_de_diagnostico_del_embarazo = ""
     @novedad.semanas_de_embarazo = ""
     @novedad.fecha_probable_de_parto = ""
     @novedad.fecha_efectiva_de_parto = ""
    end
    
    
    if @novedad.invalid?
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "edit"
      return
    end

    # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
    if
      (
        @novedad.clase_de_documento_id && !@clases_de_documentos.collect{ |i| i[1] }.member?(@novedad.clase_de_documento_id) ||
        @novedad.tipo_de_documento_id && !@tipos_de_documentos.collect{ |i| i[1] }.member?(@novedad.tipo_de_documento_id) ||
        @novedad.sexo_id && !@sexos.collect{ |i| i[1] }.member?(@novedad.sexo_id) ||
        @novedad.pais_de_nacimiento_id && !@paises.collect{ |i| i[1] }.member?(@novedad.pais_de_nacimiento_id) ||
        @novedad.lengua_originaria_id && !@lenguas_originarias.collect{ |i| i[1] }.member?(@novedad.lengua_originaria_id) ||
        @novedad.tribu_originaria_id && !@tribus_originarias.collect{ |i| i[1] }.member?(@novedad.tribu_originaria_id) ||
        @novedad.alfabetizacion_del_beneficiario_id && !@niveles_de_instruccion.collect{
          |i| i[1] }.member?(@novedad.alfabetizacion_del_beneficiario_id) ||
        @novedad.domicilio_departamento_id && !@departamentos.collect{ |i| i[1] }.member?(@novedad.domicilio_departamento_id) ||
        @novedad.domicilio_distrito_id && !@distritos.collect{ |i| i[1] }.member?(@novedad.domicilio_distrito_id) ||
        @novedad.lugar_de_atencion_habitual_id && !@efectores.collect{
          |i| i[1] }.member?(@novedad.lugar_de_atencion_habitual_id) ||
        @novedad.tipo_de_documento_de_la_madre_id && !@tipos_de_documentos.collect{
          |i| i[1] }.member?(@novedad.tipo_de_documento_de_la_madre_id) ||
        @novedad.alfabetizacion_de_la_madre_id && !@niveles_de_instruccion.collect{
          |i| i[1] }.member?(@novedad.alfabetizacion_de_la_madre_id) ||
        @novedad.tipo_de_documento_del_padre_id && !@tipos_de_documentos.collect{
          |i| i[1] }.member?(@novedad.tipo_de_documento_del_padre_id) ||
        @novedad.alfabetizacion_del_padre_id && !@niveles_de_instruccion.collect{
          |i| i[1] }.member?(@novedad.alfabetizacion_del_padre_id) ||
        @novedad.tipo_de_documento_del_tutor_id && !@tipos_de_documentos.collect{
          |i| i[1] }.member?(@novedad.tipo_de_documento_del_tutor_id) ||
        @novedad.alfabetizacion_del_tutor_id && !@niveles_de_instruccion.collect{
          |i| i[1] }.member?(@novedad.alfabetizacion_del_tutor_id) ||
        @novedad.discapacidad_id && !@discapacidades.collect{ |i| i[1] }.member?(@novedad.discapacidad_id) ||
        @novedad.centro_de_inscripcion_id && !@centros_de_inscripcion.collect{
          |i| i[1] }.member?(@novedad.centro_de_inscripcion_id)
      )
      redirect_to(root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
         :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Generar mensajes de advertencia por incompletitud (si existieran)
    @novedad.generar_advertencias

    # Registrar el usuario que realiza la modificación
    @novedad.updater_id = current_user.id

    if @novedad.advertencias && @novedad.advertencias.size > 0
      # A la solicitud le faltan datos esenciales. Guardarla, pero marcándola como incompleta.
      @novedad.estado_de_la_novedad_id = EstadoDeLaNovedad.id_del_codigo("I")
      @novedad.save
      redirect_to( novedad_del_afiliado_path(@novedad),
        :flash => { :tipo => :advertencia, :titulo => "Se guardó la solicitud, pero faltan datos esenciales",
          :mensaje => @novedad.advertencias
        }
      )
    else
      # Guardar la solicitud, marcándola como pendiente de informar
      @novedad.estado_de_la_novedad_id = 2
      @novedad.save

      if UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual]).facturacion
        # Verificar si existen prestaciones cargadas para la misma clave de beneficiario que estén pendientes y
        # actualizar los métodos de validación fallados por esas prestaciones
        PrestacionBrindada.where(:clave_de_beneficiario => @novedad.clave_de_beneficiario).each do |pb|
          if pb.pendiente?
            if !pb.actualizar_metodos_de_validacion_fallados
              pb.update_attributes({:estado_de_la_prestacion_id => EstadoDeLaPrestacion.id_del_codigo("R")})
            else
              pb.update_attributes({:estado_de_la_prestacion_id => EstadoDeLaPrestacion.id_del_codigo("F")})
            end
          end
        end
      end

      redirect_to( novedad_del_afiliado_path(@novedad),
        :flash => { :tipo => :ok, :titulo => "La solicitud se guardó correctamente" }
      )
    end
  end

  # DELETE /novedades_de_los_afiliados/:id
  def destroy
    # Verificar los permisos del usuario
    if cannot? :update, NovedadDelAfiliado
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Buscar la novedad
    begin
      @novedad = NovedadDelAfiliado.find(params[:id])

      # Verificar que la novedad esté pendiente
      if !@novedad.pendiente?
        redirect_to( root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre este incidente."
          }
        )
        return
      end

      # Buscar el afiliado asociado a esta novedad si es una modificación de datos
      if @novedad.tipo_de_novedad.codigo == "M"
        @afiliado = Afiliado.find_by_clave_de_beneficiario(@novedad.clave_de_beneficiario)
      end

    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    if @novedad.tipo_de_novedad.codigo == "A" && UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual]).facturacion
      # Verificar si existen prestaciones cargadas para la misma clave de beneficiario, que estén pendientes, en cuyo caso
      # no se permite anular la novedad
      if PrestacionBrindada.where(:clave_de_beneficiario => @novedad.clave_de_beneficiario).any? { |pb| pb.pendiente? }
        redirect_to( @novedad,
          :flash => { :tipo => :error, :titulo => "No se puede anular esta novedad",
            :mensaje => "No es posible anular esta novedad porque " +
              (@novedad.sexo.codigo == "F" ? "la beneficiaria" : "el beneficiario") +
              " tiene alguna prestación brindada pendiente de resolución asociada con esta novedad."
          }
        )
        return
      end
    end

    # Cambiar el estado de la novedad por el que corresponde a la anulación por el usuario
    @novedad.estado_de_la_novedad_id = EstadoDeLaNovedad.id_del_codigo!("U")
    @novedad.save(:validate => false)

    if UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual]).facturacion
      # Verificar si existen prestaciones cargadas para la misma clave de beneficiario que estén pendientes y
      # actualizar los métodos de validación fallados por esas prestaciones
      PrestacionBrindada.where(:clave_de_beneficiario => @novedad.clave_de_beneficiario).each do |pb|
        if pb.pendiente?
          if !pb.actualizar_metodos_de_validacion_fallados
            pb.update_attributes({:estado_de_la_prestacion_id => EstadoDeLaPrestacion.id_del_codigo("R")})
          else
            pb.update_attributes({:estado_de_la_prestacion_id => EstadoDeLaPrestacion.id_del_codigo("F")})
          end
        end
      end
    end

    # Verificar todas las prestaciones pendientes que dependen de la clave asociada a esta novedad


    redirect_to( novedad_del_afiliado_path(@novedad),
      :flash => { :tipo => :advertencia, :titulo => "La solicitud fue anulada",
        :mensaje => "Esta solicitud no podrá ser modificada ni notificada."
      }
    )
 end

 def procesar_bajas
   verificar_actualizacion

   @novedades = NovedadDelAfiliado.multi_find (
    {
      :except => ["public"],
      :where => "where estado_de_la_novedad_id = ? and tipo_de_novedad_id = ?",
      :values => [2,2]
    })

 end

 private

  def verificar_lectura
    if cannot? :update, NovedadDelAfiliado
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
  end

  def verificar_actualizacion
    if cannot? :update, NovedadDelAfiliado
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
  end

end
