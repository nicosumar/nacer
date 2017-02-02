class AgregaMotivoDeRechazoInformeDeLiquidacion < ActiveRecord::Migration
  def up
    # -*- encoding : utf-8 -*-
    # Datos precargados al inicializar el sistema
    MotivoDeRechazo.create!([
      { 
        nombre: "Cuasifactura no presentada/suscripta incorrectamente o sin suscribir.",
        categoria: "Administrativa - Sistemas" }] )

  end
end
