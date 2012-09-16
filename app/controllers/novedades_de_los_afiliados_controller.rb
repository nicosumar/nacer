class NovedadesDeLosAfiliadosController < ApplicationController
  before_filter :user_required

  def index
    # Verificar los permisos del usuario
    if cannot? :read, NovedadDelAfiliado
      redirect_to(root_url,
        :info => {:tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."})
      return
    end
  end

  def show
    # Verificar los permisos del usuario
    if cannot? :read, NovedadDelAfiliado
      redirect_to(root_url,
        :info => {:tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."})
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
          :notice => "No está autorizado para realizar esta operación. El incidente será reportado al administrador del sistema.")
        return
    end

  end

  def edit
    # Verificar los permisos del usuario
    if cannot? :update, NovedadDelAfiliado
      redirect_to(root_url,
        :notice => "No está autorizado para realizar esta operación. El incidente será reportado al administrador del sistema.")
      return
    end
  end

  def create
    # Verificar los permisos del usuario
    if cannot? :create, NovedadDelAfiliado
      redirect_to(root_url,
        :notice => "No está autorizado para realizar esta operación. El incidente será reportado al administrador del sistema.")
      return
    end

    # Obtener el tipo de novedad que se quiere guardar
    tipo_de_novedad_id = params[:novedad_del_afiliado][:tipo_de_novedad_id]
    params[:novedad_del_afiliado].delete :tipo_de_novedad_id

    case
      when tipo_de_novedad_id == 1 # ALTA

      when tipo_de_novedad_id == 2 # BAJA

      when tipo_de_novedad_id == 3 # MODIFICACIÓN
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
            :notice => "No está autorizado para realizar esta operación. El incidente será reportado al administrador del sistema.")
          return
        end

        # Eliminamos el parámetro de la clave de beneficiario (igual no se puede cambiar)
        params[:novedad_del_afiliado].delete :clave_de_beneficiario
        # Crear una novedad vacía
        @novedad = NovedadDelAfiliado.new(params[:novedad_del_afiliado])

      when tipo_de_novedad_id == 4 # REINSCRIPCIÓN
      else # ???
    end
    if !@novedad.save
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
      render :action => "new"
    end
  end

  def update
    # Verificar los permisos del usuario
    if cannot? :update, NovedadDelAfiliado
      redirect_to(root_url,
        :notice => "No está autorizado para realizar esta operación. El incidente será reportado al administrador del sistema.")
      return
    end
  end

#  def destroy
#  end

end
