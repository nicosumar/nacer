# -*- encoding : utf-8 -*-
class DetallesDeDebitosPrestacionalesController < ApplicationController
  before_filter :get_informe_de_debito
  before_filter :authenticate_user!
  before_filter :verificar_lectura
  before_filter :verificar_creacion, only: [:create, :new]

  # GET /detalles_de_debitos_prestacionales
  def index
    @detalles_de_debitos_prestacionales = @informe_de_debito.detalles_de_debitos_prestacionales
    @motivos_de_rechazo = MotivoDeRechazo.where(categoria: @informe_de_debito.tipo_de_debito_prestacional.nombre).collect {|m| [m.nombre, m.id]}
    @detalle_editable = @informe_de_debito.estado_del_proceso.id == EstadoDelProceso.where(codigo: 'C').first.id ? true : false
  end

  # POST /detalles_de_debitos_prestacionales.js
  def create

    # El detalle es solo se guarda si el estado del proceso esta en curso
    @detalle_de_debito_prestacional = @informe_de_debito.detalles_de_debitos_prestacionales.new(params[:detalle_de_debito_prestacional])
    
    if @informe_de_debito.estado_del_proceso.id == EstadoDelProceso.where(codigo: 'C').first.id 
      respond_to do |format|
        begin
          @detalle_de_debito_prestacional.save
        
        rescue ActiveRecord::RecordNotUnique
          @detalle_de_debito_prestacional.errors.add(:duplicado, "La prestación seleccionada ya ha sido cargada para ser debitada")
        rescue Exception => e
          @detalle_de_debito_prestacional.errors.add(:otro, e.message)
        end
        format.js
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  # PUT /detalles_de_debitos_prestacionales/1
  # PUT /detalles_de_debitos_prestacionales/1.json
  def update
    @detalle_de_debito_prestacional = DetalleDeDebitoPrestacional.find(params[:id])

    respond_to do |format|
      if @detalle_de_debito_prestacional.update_attributes(params[:detalle_de_debito_prestacional])
        format.html { redirect_to @detalle_de_debito_prestacional, notice: 'Detalle de debito prestacional was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @detalle_de_debito_prestacional.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @detalle_de_debito_prestacional = DetalleDeDebitoPrestacional.find(params[:id])
    #@detalle_de_debito_prestacional.destroy
  end

  private

  def get_informe_de_debito
    
    begin
      @informe_de_debito = InformeDebitoPrestacional.find(params[:informe_debito_prestacional_id])
    rescue Exception => e
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})  
    end
  end

  def verificar_lectura
    if cannot? :read, DetalleDeDebitoPrestacional
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end

  def verificar_creacion
    if cannot? :create, DetalleDeDebitoPrestacional
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end
end
