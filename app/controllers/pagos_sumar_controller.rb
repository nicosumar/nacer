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
    @efectores  = Efector.administradores_y_autoadministrados_sumar.order(:nombre).collect { |e| [e.nombre, e.id ]}
    
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

    
  end

  # POST /pagos_sumar
  # POST /pagos_sumar.json
  def create
    
    params[:pago_sumar][:nota_de_debito_ids]   = parsear_parametro_de_multiselect params[:pago_sumar], :nota_de_debito_ids
    params[:pago_sumar][:expediente_sumar_ids] = parsear_parametro_de_multiselect params[:pago_sumar], :expediente_sumar_ids

    @pago_sumar = PagoSumar.new(params[:pago_sumar])
    
    if @pago_sumar.save
      redirect_to @pago_sumar, notice: 'Se creo el proceso de pago correctamente.' 
    else
      render action: "new" 
    end
    
  end

  def notificar
    
  end

  # PUT /pagos_sumar/1
  # PUT /pagos_sumar/1.json
  def update
    @pago_sumar = PagoSumar.find(params[:id])

    respond_to do |format|
      if @pago_sumar.update_attributes(params[:pago_sumar])
        format.html { redirect_to @pago_sumar, notice: 'Pago sumar was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pago_sumar.errors, status: :unprocessable_entity }
      end
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
