# -*- encoding : utf-8 -*-
class PagosSumarController < ApplicationController
  # GET /pagos_sumar
  # GET /pagos_sumar.json
  def index
    @pagos_sumar = PagoSumar.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pagos_sumar }
    end
  end

  # GET /pagos_sumar/1
  def show
    @pago_sumar = PagoSumar.find(params[:id])
  end

  # GET /pagos_sumar/new
  def new
    @pago_sumar = PagoSumar.new
    @liquidaciones_sumar = LiquidacionSumar.joins(:periodo).order('periodos.periodo DESC').limit(50)
    @pagos_sumar = []
    if params[:pago_sumar_params].present? and params[:pago_sumar_params][:liquidacion_sumar_id].present?
      liquidacion_sumar = LiquidacionSumar.find(params[:pago_sumar_params][:liquidacion_sumar_id])
      @efectores  = Efector.administradores_y_autoadministrados_sumar.order(:nombre)
      @efectores.each do |efector|
        pago_sumar = PagoSumar.new
        pago_sumar.efector = efector
        pago_sumar.concepto_de_facturacion = liquidacion_sumar.concepto_de_facturacion
        pago_sumar.expediente_sumar = ExpedienteSumar.impagos.where(efector_id: efector, liquidacion_sumar_id: liquidacion_sumar).first      
        @pagos_sumar << pago_sumar if pago_sumar.expediente_sumar.present?
      end
    end

    @cuentas_bancarias_origen = []
    OrganismoGubernamental.gestionables.each do |og|
      og.entidad.cuentas_bancarias.each do |cbo|
        @cuentas_bancarias_origen << cbo
      end
    end

  end

  # GET /pagos_sumar/1/edit
  def edit
    @pago_sumar = PagoSumar.find(params[:id])
    @efectores   = Efector.administradores_y_autoadministrados_sumar.order(:nombre).collect { |e| [e.nombre, e.id ]}
    
    @conceptos_de_facturacion = Efector.administradores_y_autoadministrados_sumar.map do |e|
      e.conceptos_que_facturo.map do |c|
        [c.nombre, c.id, {class: e.id}]
      end
    end.flatten!(1).uniq

    @cuentas_bancarias_origen = OrganismoGubernamental.gestionables.map do |og|
      og.entidad.cuentas_bancarias.map do |cbo|
        [cbo.nombre, cbo.id, {class: og.id}]
      end
    end.flatten!(1).uniq

    @efector_id  = @pago_sumar.efector_id
    @concepto_id = @pago_sumar.concepto_de_facturacion_id
    @expedientes_sumar_ids = @pago_sumar.expediente_sumar_ids
    @cuenta_bancaria_destino_id = @pago_sumar.cuenta_bancaria_destino_id
    @cuenta_bancaria_origen_id = @pago_sumar.cuenta_bancaria_origen_id

    
  end

  # POST /pagos_sumar
  def create
    
    params[:pago_sumar][:nota_de_debito_ids]   = parsear_parametro_de_multiselect params[:pago_sumar], :nota_de_debito_ids
    params[:pago_sumar][:expediente_sumar_ids] = parsear_parametro_de_multiselect params[:pago_sumar], :expediente_sumar_ids

    @pago_sumar = PagoSumar.new(params[:pago_sumar])
    
    if @pago_sumar.save
      redirect_to @pago_sumar, notice: 'Se creo el proceso de pago correctamente.' 
    else
      @efectores   = Efector.administradores_y_autoadministrados_sumar.order(:nombre).collect { |e| [e.nombre, e.id ]}
      @conceptos_de_facturacion = Efector.administradores_y_autoadministrados_sumar.map do |e|
        e.conceptos_que_facturo.map do |c|
          [c.nombre, c.id, {class: e.id}]
        end
      end.flatten!(1).uniq

      @cuentas_bancarias_origen = OrganismoGubernamental.gestionables.map do |og|
        og.entidad.cuentas_bancarias.map do |cbo|
          [cbo.nombre, cbo.id, {class: og.id}]
        end
      end.flatten!(1).uniq
      
      render action: "new" 
    end
    
  end

  def notificar
    
  end

  # PUT /pagos_sumar/1
  def update
    params[:pago_sumar][:nota_de_debito_ids]   = parsear_parametro_de_multiselect params[:pago_sumar], :nota_de_debito_ids
    params[:pago_sumar][:expediente_sumar_ids] = parsear_parametro_de_multiselect params[:pago_sumar], :expediente_sumar_ids

    @pago_sumar = PagoSumar.find(params[:id])

    raise 'a'
    if @pago_sumar.update_attributes(params[:pago_sumar])
      redirect_to @pago_sumar, notice: 'Pago sumar was successfully updated.' 
    else
      @efectores   = Efector.administradores_y_autoadministrados_sumar.order(:nombre).collect { |e| [e.nombre, e.id ]}
      @conceptos_de_facturacion = Efector.administradores_y_autoadministrados_sumar.map do |e|
        e.conceptos_que_facturo.map do |c|
          [c.nombre, c.id, {class: e.id}]
        end
      end.flatten!(1).uniq

      @cuentas_bancarias_origen = OrganismoGubernamental.gestionables.map do |og|
        og.entidad.cuentas_bancarias.map do |cbo|
          [cbo.nombre, cbo.id, {class: og.id}]
        end
      end.flatten!(1).uniq

      @efector_id  = @pago_sumar.efector_id
      @concepto_id = @pago_sumar.concepto_de_facturacion_id
      @expedientes_sumar_ids = @pago_sumar.expediente_sumar_ids
      @cuenta_bancaria_destino_id = @pago_sumar.cuenta_bancaria_destino_id
      @cuenta_bancaria_origen_id = @pago_sumar.cuenta_bancaria_origen_id

      render action: "edit" 
    end
  end

  # DELETE /pagos_sumar/1
  # DELETE /pagos_sumar/1.json
  def destroy
    @pago_sumar = PagoSumar.find(params[:id])
    @pago_sumar.destroy

    respond_to do |format|
      format.html { redirect_to pagos_sumar_url }
      format.json { head :no_content }
    end
  end

  def parsear_parametro_de_multiselect params, simbolo
    params[simbolo].split(",").reject { |e| e.to_i == 0 }.map { |e| e.to_i }
  end
end
