# -*- encoding : utf-8 -*-
class LiquidacionesSumarCuasifacturasController < ApplicationController

  before_filter :authenticate_user!
  
  # GET /liquidaciones_sumar_cuasifacturas
  def index
    @liquidaciones_sumar_cuasifacturas = LiquidacionSumarCuasifactura.all
    @efector_administrador_administrado = busca_efector_con_consolidado
  end

  # GET /liquidaciones_sumar_cuasifacturas/1.pdf
  def show
    @liquidacion_sumar_cuasifactura = LiquidacionSumarCuasifactura.find(params[:id])

    respond_to do |format|
      format.pdf { send_data render_to_string, filename: "cuasifactura#{@liquidacion_sumar_cuasifactura.numero_cuasifactura}.pdf", 
      type: 'application/pdf', disposition: 'inline'} #'attachment'} #'inline'}
    end
  end

  private

  def busca_efector_con_consolidado
    
    # Busco todos los efectores que son administrados 
    cq = CustomQuery.buscar ({
      sql: "select distinct eadmin.id admin_id, e.id e_id \n"+
          "from convenios_de_administracion_sumar ca\n"+
          " join efectores eadmin on ca.administrador_id = eadmin.id\n"+
          " join convenios_de_gestion_sumar cg on cg.efector_id = eadmin.id \n"+
          " join efectores e on e.id = ca.efector_id\n"
      })
    return cq.collect {|a| [a.admin_id, a.e_id]}.split.flatten! 1
    
    
     
  end


  
end
