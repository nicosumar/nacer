# -*- encoding : utf-8 -*-
class LiquidacionesSumarCuasifacturasController < ApplicationController

  before_filter :authenticate_user!
  
  # GET /liquidaciones_sumar_cuasifacturas
  def index
    @liquidaciones_sumar_cuasifacturas = LiquidacionSumarCuasifactura.all
  end

  # GET /liquidaciones_sumar_cuasifacturas/1.pdf
  def show
    @liquidacion_sumar_cuasifactura = LiquidacionSumarCuasifactura.find(params[:id])
    @efector = Efector.find(@liquidacion_sumar_cuasifactura.efector.id)

    uad = UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual])
    efector_actual = uad.efector

    permitir_reporte = true

    if current_user.in_group? [:administradores, :facturacion, :auditoria_medica, :coordinacion, :planificacion, :auditoria_control, :capacitacion]
      permitir_reporte = true
    elsif current_user.in_group? [:liquidacion_adm]
      if efector_actual.es_administrador? 
       # si es administrador y quiere consultar sobre un efector que no es o bien el mismo o alguno de los administrados, lo redirijo
        permitir_reporte = false unless efector_actual == @efector or efector_actual.efectores_administrados.include? @efector 
      elsif efector_actual.es_autoadministrado?
        permitir_reporte = false unless efector_actual == @efector 
      elsif efector_actual.es_administrado?
        # si es administrado y quiere consultar sobre un efector que no es o bien su administrador o alguno de sus administrados, lo redirijo
        permitir_reporte = false unless efector_actual.administrador_sumar.efectores_administrados.include? @efector or efector_actual.administrador_sumar == @efector
      end
    elsif current_user.in_group? [:facturacion_uad] 
      if efector_actual.es_administrador? 
        permitir_reporte = false unless efector_actual == @efector or efector_actual.efectores_administrados.include? @efector 
      elsif efector_actual.es_autoadministrado?
        permitir_reporte = false unless efector_actual == @efector 
      elsif efector_actual.es_administrado? 
        permitir_reporte = false unless Efector.where("unidad_de_alta_de_datos_id = '?' OR id = '?'", uad.id, efector_actual.id).include? @efector 
      end
    end

    unless permitir_reporte 
      redirect_to( root_url, 
          :flash => { :tipo => :error, 
                      :titulo => "No está autorizado para acceder a esta cuasifactura", 
                      :mensaje => "Se informará al administrador del sistema sobre este incidente."
                    })
      return
    end

    respond_to do |format|
      format.pdf { send_data render_to_string, filename: "cuasifactura#{@liquidacion_sumar_cuasifactura.numero_cuasifactura}.pdf", 
      type: 'application/pdf', disposition: 'attachment'}
    end #end respond to

  end #end method

end
