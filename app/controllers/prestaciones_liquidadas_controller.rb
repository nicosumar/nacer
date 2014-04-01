# -*- encoding : utf-8 -*-
class PrestacionesLiquidadasController < ApplicationController

  # def ver_prestaciones_liquidadas
  #   @prestaciones_liquidadas = PrestacionLiquidada.where(liquidacion_id: params[:id]).paginate(:page => params[:page], :per_page => 20)
  # end

  def por_afiliado

    if params[:afiliado_id]
      @prestaciones_liquidadas = Afiliado.includes(:prestaciones_liquidadas).find(params[:afiliado_id]).prestaciones_liquidadas.where(estado_de_la_prestacion_liquidada_id: 12)
      if @prestaciones_liquidadas.present? and @prestaciones_liquidadas.size > 0
        @prestaciones_liquidadas.map!{ |p| {id:p.id, text: "#{p.codigo}" }}

      end
    

    end
###########3
    @afiliados = Afiliado.busqueda_por_aproximacion(numero, nombres.join(" "))
    if @afiliados[0].present? and @afiliados[0].size > 0
      @afiliados[0].map!{ |af| {id: af.afiliado_id, text: "#{af.nombre}, #{af.apellido} (#{af.tipo_de_documento.codigo}: #{af.numero_de_documento})"}}
    end
    #.paginate(:page => x, :per_page => y)
    respond_to do |format|
      if @afiliados[0].present? and @afiliados[0].size > 0
        format.json { 
          render json: {total: @afiliados[0].size ,afiliados: @afiliados[0].paginate(:page => x, :per_page => y) } }
      else
        format.json { render json: {total: 0, afiliados: []}  }
      end
    end
###########3

    #rescue Exception => e
    #  redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})  
    #end
  	
  end

end
