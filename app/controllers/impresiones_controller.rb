class ImpresionesController < ApplicationController
  def cuasifacturas
  end

  def consolidados
  	# Valores para los dropdown
  	@efectores = Efector.find(:all).collect {|i| [i.nombre, i.id]}
  	@periodos = Periodo.find(:all).include(:concepto_de_facturacion).collect {|i| ["#{i.periodo} - #{i.concepto_de_facturacion.nombre}", i.id]}


  end
end
