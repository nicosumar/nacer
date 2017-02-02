class LiquidacionesSumarCuasifacturasDetallesController < ApplicationController
  # GET /liquidaciones_sumar_cuasifacturas_detalles
  # GET /liquidaciones_sumar_cuasifacturas_detalles.json
  def index
    @liquidaciones_sumar_cuasifacturas_detalles = LiquidacionSumarCuasifacturaDetalle.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @liquidaciones_sumar_cuasifacturas_detalles }
    end
  end

  # GET /liquidaciones_sumar_cuasifacturas_detalles/1
  # GET /liquidaciones_sumar_cuasifacturas_detalles/1.json
  def show
    @liquidacion_sumar_cuasifactura_detalle = LiquidacionSumarCuasifacturaDetalle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @liquidacion_sumar_cuasifactura_detalle }
    end
  end

  # GET /liquidaciones_sumar_cuasifacturas_detalles/new
  # GET /liquidaciones_sumar_cuasifacturas_detalles/new.json
  def new
    @liquidacion_sumar_cuasifactura_detalle = LiquidacionSumarCuasifacturaDetalle.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @liquidacion_sumar_cuasifactura_detalle }
    end
  end

  # GET /liquidaciones_sumar_cuasifacturas_detalles/1/edit
  def edit
    @liquidacion_sumar_cuasifactura_detalle = LiquidacionSumarCuasifacturaDetalle.find(params[:id])
  end

  # POST /liquidaciones_sumar_cuasifacturas_detalles
  # POST /liquidaciones_sumar_cuasifacturas_detalles.json
  def create
    @liquidacion_sumar_cuasifactura_detalle = LiquidacionSumarCuasifacturaDetalle.new(params[:liquidacion_sumar_cuasifactura_detalle])

    respond_to do |format|
      if @liquidacion_sumar_cuasifactura_detalle.save
        format.html { redirect_to @liquidacion_sumar_cuasifactura_detalle, notice: 'Liquidacion sumar cuasifactura detalle was successfully created.' }
        format.json { render json: @liquidacion_sumar_cuasifactura_detalle, status: :created, location: @liquidacion_sumar_cuasifactura_detalle }
      else
        format.html { render action: "new" }
        format.json { render json: @liquidacion_sumar_cuasifactura_detalle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /liquidaciones_sumar_cuasifacturas_detalles/1
  # PUT /liquidaciones_sumar_cuasifacturas_detalles/1.json
  def update
    @liquidacion_sumar_cuasifactura_detalle = LiquidacionSumarCuasifacturaDetalle.find(params[:id])

    respond_to do |format|
      if @liquidacion_sumar_cuasifactura_detalle.update_attributes(params[:liquidacion_sumar_cuasifactura_detalle])
        format.html { redirect_to @liquidacion_sumar_cuasifactura_detalle, notice: 'Liquidacion sumar cuasifactura detalle was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @liquidacion_sumar_cuasifactura_detalle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /liquidaciones_sumar_cuasifacturas_detalles/1
  # DELETE /liquidaciones_sumar_cuasifacturas_detalles/1.json
  def destroy
    @liquidacion_sumar_cuasifactura_detalle = LiquidacionSumarCuasifacturaDetalle.find(params[:id])
    @liquidacion_sumar_cuasifactura_detalle.destroy

    respond_to do |format|
      format.html { redirect_to liquidaciones_sumar_cuasifacturas_detalles_url }
      format.json { head :no_content }
    end
  end
end
