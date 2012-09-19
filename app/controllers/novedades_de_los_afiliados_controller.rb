class NovedadesDeLosAfiliadosController < ApplicationController
  before_filter :user_required

  def index
    # Verificar los permisos del usuario
    if cannot? :read, NovedadDelAfiliado
      redirect_to(
        root_url,
        :info => {
          :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
  end

  def show
    # Verificar los permisos del usuario
    if cannot? :read, NovedadDelAfiliado
      redirect_to(
        root_url,
        :info => {
          :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Buscar la novedad
    begin
      @novedad = NovedadDelAfiliado.find(
        params[:id],
        :include => [
          :clase_de_documento, :tipo_de_documento, :sexo, :pais_de_nacimiento, :lengua_originaria,
          :tribu_originaria, :alfabetizacion_del_beneficiario, :domicilio_departamento,
          :domicilio_distrito, :lugar_de_atencion_habitual, :tipo_de_documento_de_la_madre,
          :alfabetizacion_de_la_madre, :tipo_de_documento_del_padre, :alfabetizacion_del_padre,
          :tipo_de_documento_del_tutor, :alfabetizacion_del_tutor, :discapacidad, :centro_de_inscripcion
        ]
      )
      if @novedad.tipo_de_novedad_id == 3
        @afiliado = Afiliado.find_by_clave_de_beneficiario(
          @novedad.clave_de_beneficiario,
          :include => [
            :clase_de_documento, :tipo_de_documento, :sexo, :pais_de_nacimiento, :lengua_originaria,
            :tribu_originaria, :alfabetizacion_del_beneficiario, :domicilio_departamento,
            :domicilio_distrito, :lugar_de_atencion_habitual, :tipo_de_documento_de_la_madre,
            :alfabetizacion_de_la_madre, :tipo_de_documento_del_padre, :alfabetizacion_del_padre,
            :tipo_de_documento_del_tutor, :alfabetizacion_del_tutor, :discapacidad
          ]
        )
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to(
        root_url,
        :info => {
          :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

  end

  def new
    # Verificar los permisos del usuario
    if cannot? :create, NovedadDelAfiliado
      redirect_to(root_url,
        :info => {:tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."})
      return
    end

    # Verificar que se haya indicado el tipo de novedad
    if !params[:tipo_de_novedad_id]
      redirect_to(root_url,
        :info => {:tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."})
      return
    end

    # Crear el objeto requerido para generar el formulario
    @novedad = NovedadDelAfiliado.new

    # Actuar de acuerdo con el tipo de novedad solicitado
    case
      when params[:tipo_de_novedad_id] == "1" # Alta
      when params[:tipo_de_novedad_id] == "2" # Baja
      when params[:tipo_de_novedad_id] == "3" # Modificación
        # Verificar que se haya pasado el ID del afiliado que se modificará
        if !params[:afiliado_id]
          redirect_to(root_url,
            :info => {:tipo => :error, :titulo => "La petición no es válida",
              :mensaje => "Se informará al administrador del sistema sobre este incidente."})
          return
        end

        # Buscar el afiliado
        begin
          @afiliado = Afiliado.find(params[:afiliado_id])
        rescue ActiveRecord::RecordNotFound
          redirect_to(root_url,
            :info => {:tipo => :error, :titulo => "La petición no es válida",
              :mensaje => "Se informará al administrador del sistema sobre este incidente."})
          return
        end

        # Verificar que este afiliado no tenga una novedad pendiente
        if @afiliado.novedad_pendiente?
          redirect_to(
            root_url,
            :info => {
              :tipo => :error, :titulo => "La petición no es válida",
              :mensaje => "Se informará al administrador del sistema sobre este incidente."
            }
          )
          return
        end

        # Asignar valores a los atributos de la novedad
        @novedad.tipo_de_novedad_id = 3   # Modificación
        @novedad.copiar_atributos_del_afiliado(@afiliado)

        # Crear objetos para rellenar las colecciones de las listas de selección
        @clases_de_documentos = ClaseDeDocumento.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
        @tipos_de_documentos = TipoDeDocumento.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
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
        @efectores = Efector.ordenados_por_frecuencia(:novedades_de_los_afiliados,
          :lugar_de_atencion_habitual_id).collect{ |i| [i.nombre, i.id]}
        @discapacidades = Discapacidad.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
        @centros_de_inscripcion = uad_actual.centros_de_inscripcion.collect{ |i| [i.nombre, i.id]}.sort

      when params[:tipo_de_novedad_id] == "4" # Reinscripción
      else # Tipo de novedad desconocida. ¿Petición fraguada?
        redirect_to(root_url,
          :info => {:tipo => :error, :titulo => "No está autorizado para acceder a esta página",
            :mensaje => "Se informará al administrador del sistema sobre este incidente."})
        return
    end

  end

  def edit
    # Verificar los permisos del usuario
    if cannot? :update, NovedadDelAfiliado
      redirect_to(
        root_url,
        :info => {
          :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Buscar la novedad
    begin
      @novedad = NovedadDelAfiliado.find(params[:id])
      if @novedad.tipo_de_novedad_id == 3
        @afiliado = Afiliado.find_by_clave_de_beneficiario(@novedad.clave_de_beneficiario)
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to(
        root_url,
        :info => {
          :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear objetos para rellenar las colecciones de las listas de selección
    @clases_de_documentos = ClaseDeDocumento.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @tipos_de_documentos = TipoDeDocumento.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
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
    @efectores = Efector.ordenados_por_frecuencia(:novedades_de_los_afiliados,
      :lugar_de_atencion_habitual_id).collect{ |i| [i.nombre, i.id]}
    @discapacidades = Discapacidad.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
    @centros_de_inscripcion = uad_actual.centros_de_inscripcion.collect{ |i| [i.nombre, i.id]}.sort

  end

  def create
    # Verificar los permisos del usuario
    if cannot? :create, NovedadDelAfiliado
      redirect_to(
        root_url,
        :info => {
          :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el tipo de novedad que se quiere guardar
    tipo_de_novedad_id = params[:novedad_del_afiliado][:tipo_de_novedad_id]
    params[:novedad_del_afiliado].delete :tipo_de_novedad_id

    case
      when tipo_de_novedad_id == "1" # ALTA

      when tipo_de_novedad_id == "2" # BAJA

      when tipo_de_novedad_id == "3" # MODIFICACIÓN
        # Verificar que se haya pasado el ID del afiliado que se modificará
        if !params[:afiliado_id]
          redirect_to(
            root_url,
            :info => {
              :tipo => :error, :titulo => "La petición no es válida",
              :mensaje => "Se informará al administrador del sistema sobre este incidente."
            }
          )
          return
        end

        # Buscar el afiliado
        begin
          @afiliado = Afiliado.find(params[:afiliado_id])
        rescue ActiveRecord::RecordNotFound
          redirect_to(root_url,
            :info => {:tipo => :error, :titulo => "La petición no es válida",
              :mensaje => "Se informará al administrador del sistema sobre este incidente."})
          return
        end

        # Eliminamos el parámetro de la clave de beneficiario (igual no se puede cambiar)
        params[:novedad_del_afiliado].delete :clave_de_beneficiario

        # Creamos una nueva novedad y copiamos los datos del afiliado
        @novedad = NovedadDelAfiliado.new
        @novedad.copiar_atributos_del_afiliado(@afiliado)

        # Si la clase de documento del beneficiario es 'Propio', eliminar el parámetro ya que no se puede cambiar
        if @novedad.clase_de_documento_id == 1
          params[:novedad_del_afiliado].delete :clase_de_documento_id
        end

        # Actualizar el resto de los atributos con los valores pasados en los parámetros
        @novedad.attributes = params[:novedad_del_afiliado]
        @novedad.tipo_de_novedad_id = 3
        @novedad.categoria_de_afiliado_id = @novedad.categorizar

      when tipo_de_novedad_id == "4" # REINSCRIPCIÓN
      else # ???
    end

    if @novedad.invalid?
      # Si hay errores en los datos ingresados, volver a mostrar el formulario con el detalle de los errores
      @clases_de_documentos = ClaseDeDocumento.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
      @tipos_de_documentos = TipoDeDocumento.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
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
      @efectores = Efector.ordenados_por_frecuencia(:novedades_de_los_afiliados,
        :lugar_de_atencion_habitual_id).collect{ |i| [i.nombre, i.id]}
      @discapacidades = Discapacidad.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
      @centros_de_inscripcion = uad_actual.centros_de_inscripcion.collect{ |i| [i.nombre, i.id]}.sort
      render :action => "new"
    else
      if @novedad.advertencias && @novedad.advertencias.size > 0
        # A la solicitud le faltan datos esenciales. Guardarla, pero marcándola como incompleta.
        @novedad.estado_de_la_novedad_id = 1
        @novedad.save
        redirect_to(
          novedad_del_afiliado_path(@novedad),
          :info => {
            :tipo => :advertencia,
            :titulo => "Se guardó la solicitud, pero faltan datos esenciales",
            :mensaje => @novedad.advertencias
          }
        )
      else
        # Guardar la solicitud, marcándola como pendiente de informar
        @novedad.estado_de_la_novedad_id = 2
        @novedad.save
        redirect_to(
          novedad_del_afiliado_path(@novedad),
          :info => {:tipo => :ok, :titulo => "La solicitud se guardó correctamente"}
        )
      end
    end
  end

  def update
    # Verificar los permisos del usuario
    if cannot? :update, NovedadDelAfiliado
      redirect_to(
        root_url,
        :info => {
          :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Buscar la novedad
    begin
      @novedad = NovedadDelAfiliado.find(params[:id])
      if @novedad.tipo_de_novedad_id == 3
        @afiliado = Afiliado.find_by_clave_de_beneficiario(@novedad.clave_de_beneficiario)
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to(
        root_url,
        :info => {
          :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Eliminar parámetros que no se pueden asignar masivamente
    params[:novedad_del_afiliado].delete :tipo_de_novedad_id
    params[:novedad_del_afiliado].delete :clave_de_beneficiario
    if @novedad.clase_de_documento_id == 1
      params[:novedad_del_afiliado].delete :clase_de_documento_id
    end

    case
      when @novedad.tipo_de_novedad_id == 1 # ALTA

      when @novedad.tipo_de_novedad_id == 2 # BAJA

      when @novedad.tipo_de_novedad_id == 3 # MODIFICACIÓN
        # Actualizar los atributos que se pueden cambiar masivamente
        @novedad.attributes = params[:novedad_del_afiliado]

      when tipo_de_novedad_id == "4" # REINSCRIPCIÓN
      else # ???
    end

    if @novedad.invalid?
      # Si hay errores en los datos ingresados, volver a mostrar el formulario con el detalle de los errores
      @clases_de_documentos = ClaseDeDocumento.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
      @tipos_de_documentos = TipoDeDocumento.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
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
      @efectores = Efector.ordenados_por_frecuencia(:novedades_de_los_afiliados,
        :lugar_de_atencion_habitual_id).collect{ |i| [i.nombre, i.id]}
      @discapacidades = Discapacidad.find(:all, :order => :id).collect{ |i| [i.nombre, i.id]}
      @centros_de_inscripcion = uad_actual.centros_de_inscripcion.collect{ |i| [i.nombre, i.id]}.sort
      render :action => "edit"
    else
      if @novedad.advertencias && @novedad.advertencias.size > 0
        # A la solicitud le faltan datos esenciales. Guardarla, pero marcándola como incompleta.
        @novedad.estado_de_la_novedad_id = 1
        @novedad.save
        redirect_to(
          novedad_del_afiliado_path(@novedad),
          :info => {
            :tipo => :advertencia,
            :titulo => "Se guardó la solicitud, pero faltan datos esenciales",
            :mensaje => @novedad.advertencias
          }
        )
      else
        # Guardar la solicitud, marcándola como pendiente de informar
        @novedad.estado_de_la_novedad_id = 2
        @novedad.save
        redirect_to(
          novedad_del_afiliado_path(@novedad),
          :info => {:tipo => :ok, :titulo => "La solicitud se guardó correctamente"}
        )
      end
    end
  end

#  def destroy
#  end

end
