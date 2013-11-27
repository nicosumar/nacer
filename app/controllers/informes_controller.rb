# -*- encoding : utf-8 -*-
class InformesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :verificar_permisos

  #Los renders de informes deben comenzar con "_render_"
  def render_informe
    @informe = Informe.find(params[:reporte][:id])

    #traigo los parametros del reporte y los ordeno para el query
    valores = []
    params[:reporte][:parametros].sort.each { |p, v| valores << v} unless params[:reporte][:parametros].blank?

    #Al ser todos o incluidos o excluidos, busco los codigos, y despues verifico si se incluye o excluye
    if @informe.informes_uads.first.incluido == 1
      @cq = CustomQuery.buscar (
        {
          esquemas: @informe.esquemas,
          #except: ["public"],
          sql: @informe.sql,
          values: valores
        })
    else
      @cq = CustomQuery.buscar (
        {
          except: @informe.esquemas,
          #except: ["public"],
          sql: @informe.sql,
          values: valores
        })

    end

    # cq = CustomQuery.buscar (
    # {
    #   ( ? { esquemas: esquemas } : { except: esquemas} ),
    #   sql: @informe.sql,
    #   values: [],

    #   #:except => ["public"],
    #   :sql => " select u.email, u.nombre, u.apellido, uad.nombre UAD , count(nov.*)
    #              from users u
    #               left join novedades_de_los_afiliados nov on nov.creator_id = u.id
    #               join unidades_de_alta_de_datos_users uadu on uadu.user_id = u.id
    #               join unidades_de_alta_de_datos uad on uad.id = uadu.unidad_de_alta_de_datos_id
    #             where u.confirmed_at < '2013-04-01'
    #             and   (nov.created_at between '2013-04-01' and '2013-04-30' or nov.created_at is null) and
    #             'uad_' ||  uad.codigo = current_schema()
    #             group by u.email, u.nombre, u.apellido, uad "
    # })
  end

  def beneficiarios_activos
    # Verificar los permisos del usuario
    if not current_user.in_group?(:coordinacion)
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el último periodo procesado
    anio, mes, dia = ActiveRecord::Base.connection.exec_query(
        "SELECT DISTINCT fecha_de_inicio
           FROM periodos_de_actividad
           ORDER BY fecha_de_inicio DESC LIMIT 1"
      ).rows[0][0].split("-").collect{ |i| i.to_i }
    @ultimo_periodo = Date.new(anio, mes, dia)

    # Determinar el periodo que se evalúa
    if params[:mes_y_anio]
      @fecha_base = parametro_fecha(params[:mes_y_anio], :mes_y_anio)
    else
      # De forma predeterminada mostramos los datos del último mes procesado
      @fecha_base = @ultimo_periodo
    end

    if @fecha_base > @ultimo_periodo
      redirect_to( informe_de_beneficiarios_activos_url,
        :flash => { :tipo => :advertencia, :titulo => "El periodo aún no se ha procesado",
          :mensaje => "El periodo que seleccionó aún no ha sido procesado. Se muestran datos del último periodo procesado."
        }
      )
      return
    end

    # Obtener los beneficiarios activos por grupo etario para el periodo evaluado
    @menores_de_6_activos = Afiliado.menores_de_6_activos(@fecha_base)
    @de_6_a_9_activos = Afiliado.de_6_a_9_activos(@fecha_base)
    @adolescentes_activos = Afiliado.adolescentes_activos(@fecha_base)
    @mujeres_de_20_a_64_activas = Afiliado.mujeres_de_20_a_64_activas(@fecha_base)
    @embarazadas_adolescentes_activas = Afiliado.embarazadas_adolescentes_activas(@fecha_base)
    @embarazadas_de_20_a_64_activas = Afiliado.embarazadas_de_20_a_64_activas(@fecha_base)
  end

  def tablero_de_comandos_alto_impacto
    # Verificar los permisos del usuario
    if not current_user.in_group?(:coordinacion)
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el último periodo procesado
    anio, mes, dia = ActiveRecord::Base.connection.exec_query(
        "SELECT DISTINCT fecha_de_inicio
           FROM periodos_de_actividad
           ORDER BY fecha_de_inicio DESC LIMIT 1"
      ).rows[0][0].split("-").collect{ |i| i.to_i }
    @ultimo_periodo = Date.new(anio, mes, dia)

    # Determinar el periodo que se evalúa
    if params[:mes_y_anio]
      @fecha_base = parametro_fecha(params[:mes_y_anio], :mes_y_anio)
    else
      # De forma predeterminada mostramos los datos del último mes procesado
      @fecha_base = @ultimo_periodo
    end

    if @fecha_base > @ultimo_periodo
      redirect_to( tablero_de_comandos_alto_impacto_path,
        :flash => { :tipo => :advertencia, :titulo => "El periodo aún no se ha procesado",
          :mensaje => "El periodo que seleccionó aún no ha sido procesado. Se muestran datos del último periodo procesado."
        }
      )
      return
    end

    # Obtener los datos que requiere el informe
    @datos_de_cobertura =
      ActiveRecord::Base.connection.exec_query "
        SELECT
          ef.nombre AS \"Efector\",
          SUM(
            CASE
              WHEN (pc.fecha_de_inicio IS NULL) THEN
                1::int8
              ELSE
                0::int8
            END
          ) AS \"Beneficiarios activos sin C.E.B.\",
          SUM(
            CASE
              WHEN (pc.fecha_de_inicio IS NOT NULL AND af.efector_ceb_id = ef.id AND af.fecha_de_la_ultima_prestacion IS NOT NULL) THEN
                1::int8
              ELSE
                0::int8
            END
          ) AS \"Beneficiarios activos con C.E.B. del efector\",
          SUM(
            CASE
              WHEN (pc.fecha_de_inicio IS NOT NULL AND (af.efector_ceb_id != ef.id OR af.efector_ceb_id IS NULL) AND af.fecha_de_la_ultima_prestacion IS NOT NULL) THEN
                1::int8
              ELSE
                0::int8
            END
          ) AS \"Beneficiarios activos con C.E.B. de otro efector\",
          SUM(
            CASE
              WHEN (pc.fecha_de_inicio IS NOT NULL AND af.fecha_de_la_ultima_prestacion IS NULL) THEN
                1::int8
              ELSE
                0::int8
            END
          ) AS \"Beneficiarios activos con C.E.B. por inscripción\"
          FROM afiliados af
            LEFT JOIN efectores ef ON (af.lugar_de_atencion_habitual_id = ef.id)
            LEFT JOIN periodos_de_actividad pa ON (af.afiliado_id = pa.afiliado_id)
            LEFT JOIN periodos_de_cobertura pc
              ON (
                af.afiliado_id = pc.afiliado_id AND pc.fecha_de_inicio <= '#{@fecha_base.strftime("%Y-%m-%d")}'
                AND (pc.fecha_de_finalizacion IS NULL OR pc.fecha_de_finalizacion > '#{@fecha_base.strftime("%Y-%m-%d")}')
              )
          WHERE
            pa.fecha_de_inicio <= '#{@fecha_base.strftime("%Y-%m-%d")}'
            AND (pa.fecha_de_finalizacion IS NULL OR pa.fecha_de_finalizacion > '#{@fecha_base.strftime("%Y-%m-%d")}')
            AND ef.alto_impacto
          GROUP BY ef.nombre;
      "
  end

  def index
      @reportes = Informe.all
  end

  def usuarios_inscripciones


    @usrinsc = CustomQuery.buscar (
    {
      :except => ["public"],
      :sql => " select u.email, u.nombre, u.apellido, uad.nombre UAD , count(nov.*)
                 from users u
                  left join novedades_de_los_afiliados nov on nov.creator_id = u.id
                  join unidades_de_alta_de_datos_users uadu on uadu.user_id = u.id
                  join unidades_de_alta_de_datos uad on uad.id = uadu.unidad_de_alta_de_datos_id
                where u.confirmed_at < '2013-04-01'
                and   (nov.created_at between '2013-04-01' and '2013-04-30' or nov.created_at is null) and
                'uad_' ||  uad.codigo = current_schema()
                group by u.email, u.nombre, u.apellido, uad "
    })
    respond_to do |format|
      format.html
      format.js
    end

    Informe.create!({:sql => "select u.email, u.nombre, u.apellido, uad.nombre UAD , count(nov.*)
                    from users u
                       left join novedades_de_los_afiliados nov on nov.creator_id = u.id
                       join unidades_de_alta_de_datos_users uadu on uadu.user_id = u.id
                       join unidades_de_alta_de_datos uad on uad.id = uadu.unidad_de_alta_de_datos_id
                    where u.confirmed_at < '2014-06-01'
                    and   (nov.created_at between '2010-04-01' and '2013-08-30' or nov.created_at is null)
                    and   'uad_' ||  uad.codigo = current_schema()
                    group by u.email, u.nombre, u.apellido, uad",
      :titulo => 'Cargas por Usuario',
      :metodo_en_controller => 'novedades_usuarios',
      :formato => 'html'

      })

  end


  def new
    @informe = Informe.new
    #@controller_metodos = (InformesController.action_methods - ApplicationController.action_methods).to_a.select{|s| s =~ /render_informe_/}
    @controller_metodos = (Dir.glob("**/app/views*/informes/_render_**")).collect { |s| (s.split "/").last.split(".").first.split("_").last }
    @formatos = ['html']
    @esquemas = UnidadDeAltaDeDatos.all
    esquema = UnidadDeAltaDeDatos.new(nombre: 'Todos')
    esquema.id = 0
    @esquemas << esquema
    @esquemas_informes = @informe.esquemas.build
    @validadores_ui = InformeFiltroValidadorUi.all.collect {|vui| [vui.tipo, vui.id]}

  end

  def create

    @informe = Informe.new(params[:informe])

    #Elimina espacios extras y retornos de carro
    @informe.sql = @informe.sql.split.join(" ")

    params[:informe_esquema][:id].each do |ie|
      unless ie.blank?
        if ie == '0'
          UnidadDeAltaDeDatos.all.each do |u|
            @informe.informes_uads.build unidad_de_alta_de_datos_id: u.id, incluido: (params[:incluido] )
          end
        else
          @informe.informes_uads.build unidad_de_alta_de_datos_id: ie, incluido: (params[:incluido] )
        end
      end
    end

    if @informe.save
      redirect_to(:action => 'index')
    else
      @controller_metodos = (Dir.glob("**/app/views*/informes/_render_**")).collect { |s| (s.split "/").last.split(".").first.split("_").last }
      @formatos = ['html']
      @esquemas = UnidadDeAltaDeDatos.all
      esquema = UnidadDeAltaDeDatos.new(nombre: 'Todos')
      esquema.id = 0
      @esquemas << esquema
      @esquemas_informes = @informe.esquemas.build
      @validadores_ui = InformeFiltroValidadorUi.all.collect {|vui| [vui.tipo, vui.id]}

      render(:action => "new")
    end
  end

  private

  def verificar_permisos
    if not current_user.in_group? [:coordinacion, :facturacion, :capacitacion, :comunicacion, :planificacion]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
  end



end
