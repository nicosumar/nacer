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
  # GET /pagos_sumar/1.json
  def show
    @pago_sumar = PagoSumar.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pago_sumar }
    end
  end

  # GET /pagos_sumar/new
  def new
    @pago_sumar = PagoSumar.new
    @pago_sumar.expedientes_sumar.build
    @pago_sumar.aplicaciones_de_notas_de_debito.build

    @efectores = Efector.administradores_y_autoadministrados_sumar.order(:nombre).collect { |e| [e.nombre, e.id ]}

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
  end

  # POST /pagos_sumar
  # POST /pagos_sumar.json
  def create

    @pago_sumar = PagoSumar.new(params[:pago_sumar])

    #raise 'll'

    respond_to do |format|
      if @pago_sumar.save
        format.html { redirect_to @pago_sumar, notice: 'Pago sumar was successfully created.' }
        format.json { render json: @pago_sumar, status: :created, location: @pago_sumar }
      else
        format.html { render action: "new" }
        format.json { render json: @pago_sumar.errors, status: :unprocessable_entity }
      end
    end
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
end
