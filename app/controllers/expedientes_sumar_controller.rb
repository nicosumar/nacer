# -*- encoding : utf-8 -*-
class ExpedientesSumarController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verificar_lectura
  before_filter :verificar_creacion, only: [:create, :new]

  def generar_caratulas_expedientes_por_liquidacion
     @liquidacion_sumar = LiquidacionSumar.find(params[:id])
    
    if LiquidacionInforme.where(liquidacion_sumar_id: @liquidacion_sumar.id).size >=1
      respond_to do |format|
        format.pdf { send_data render_to_string, filename: "Rotulos Exptes Per #{@liquidacion_sumar.periodo.periodo}_#{@liquidacion_sumar.grupo_de_efectores_liquidacion.grupo}.pdf", type: 'application/pdf', disposition: 'attachment'}
      end
    else
      redirect_to( @liquidacion_sumar, :flash => { :tipo => :error, :titulo => "Debe generar las cuasifacturas primero"})
    end
  end

  # GET /expedientes_sumar/impagos_por_Efector
  def impagos_por_efector
    begin
      cadena = params[:q]
      x = params[:page]
      y = params[:per]

      efector = Efector.find(params[:parametros_adicionales][:pago_sumar_efector_id])
      concepto = ConceptoDeFacturacion.find(params[:parametros_adicionales][:pago_sumar_concepto_de_facturacion_id])

      @expedientes = ExpedienteSumar.del_concepto_de_facturacion(concepto)
                                    .where(efector_id: efector.id)
                                    .where("expedientes_sumar.numero ilike ?", "%#{cadena}%")

      @expedientes.map! do |ex|
        {
          id: ex.id,
          numero: ex.numero,
          # efector: efector.nombre,
          monto_aprobado: ex.monto_aprobado,
          #liquidaciones_informes: ex.liquidaciones_informes.map { |li| {id: li.id, monto: li.monto_aprobado} },
          periodo: ex.liquidacion_sumar.periodo.periodo
        }
      end

      respond_to do |format|
          format.json {
            render json: {total: @expedientes.size ,expedientes: @expedientes }
          }
      end

    rescue Exception => e
      respond_to do |format|
        format.json {
          render json: {total: 0, expedientes: [] }, status: :ok
        }
      end #end response
    end #end begin rescue
    
  end #end impagos por efector

  private

  def verificar_lectura 
    if cannot? :read, LiquidacionSumar
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end

  def verificar_creacion
    if cannot? :create, LiquidacionSumar
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end
end
