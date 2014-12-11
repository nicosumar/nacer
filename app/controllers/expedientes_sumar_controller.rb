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
    #begin
      cadena = params[:q].split(" ")
      x = params[:page]
      y = params[:per]

      efector = Efector.find(params[:parametros_adicionales][:pago_sumar_efector_id])
      @expedientes = ExpedienteSumar.impagos_por_efector efector

      @expedientes.map! do |ex|
        {
          id: ex.id,
          numero: ex.numero,
          liquidaciones_informes: ex.liquidaciones_informes.map { |li| [id: li.id, monto: li.monto_aprobado] },
          periodo: ex.liquidacion_sumar.periodo.periodo
        }
      end

      respond_to do |format|
          format.json {
            render json: {total: @expedientes.size ,expedientes: @expedientes }
          }
      end
      
      #render json: @expedientes, status: :ok
      
      
    #rescue Exception => e
     # render json: {total: 0, expedientes: []}  }, status: :ok
    #end
  end

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
