# -*- encoding : utf-8 -*-
class PrestacionesLiquidadasController < ApplicationController

  # GET /prestaciones_liquidadas/1
  def show
    @prestaciones_liquidadas = PrestacionLiquidada.all
  end

end
