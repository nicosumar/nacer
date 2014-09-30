# -*- encoding : utf-8 -*-
class ConsolidadosSumarController < ApplicationController
  
  # GET /consolidados_sumar/1.pdf
  def show
    @consolidado_sumar = ConsolidadoSumar.find(params[:id])

    @efector = Efector.find(@consolidado_sumar.efector.id)

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
    end

    unless permitir_reporte 
      redirect_to( root_url, 
          :flash => { :tipo => :error, 
                      :titulo => "No está autorizado para acceder a esta cuasifactura", 
                      :mensaje => "Se informará al administrador del sistema sobre este incidente."
                    })
      return
    end

    if  @consolidado_sumar.liquidacion_sumar.concepto_de_facturacion.present? and 
        @consolidado_sumar.periodo.present? and 
        @consolidado_sumar.efector.present? and
        @consolidado_sumar.fecha.present?

      respond_to do |format|
        format.pdf { send_data render_to_string, filename: "consolidadosumar#{@consolidado_sumar.numero_de_consolidado}.pdf", 
        type: 'application/pdf', disposition: 'attachment'} #'attachment'} #'inline'}
      end
    end
  end

 
end
