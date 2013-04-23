# -*- encoding : utf-8 -*-
class InformesController < ApplicationController
  before_filter :authenticate_user!

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

end
