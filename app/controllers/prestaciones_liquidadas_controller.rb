# -*- encoding : utf-8 -*-
class PrestacionesLiquidadasController < ApplicationController

  def ver_prestaciones_liquidadas
    @prestaciones_liquidadas = PrestacionLiquidada.where(liquidacion_id: params[:id]).paginate(:page => params[:page], :per_page => 20)
  end

end
