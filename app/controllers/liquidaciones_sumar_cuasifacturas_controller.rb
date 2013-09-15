class LiquidacionesSumarCuasifacturasController < ApplicationController
  # GET /liquidaciones_sumar_cuasifacturas
  # GET /liquidaciones_sumar_cuasifacturas.json
  def index
    @liquidaciones_sumar_cuasifacturas = LiquidacionSumarCuasifactura.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @liquidaciones_sumar_cuasifacturas }
    end
  end

  # GET /liquidaciones_sumar_cuasifacturas/1
  # GET /liquidaciones_sumar_cuasifacturas/1.json
  def show
    @liquidacion_sumar_cuasifactura = LiquidacionSumarCuasifactura.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @liquidacion_sumar_cuasifactura }
    end
  end

  # GET /liquidaciones_sumar_cuasifacturas/new
  # GET /liquidaciones_sumar_cuasifacturas/new.json
  def new
    @liquidacion_sumar_cuasifactura = LiquidacionSumarCuasifactura.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @liquidacion_sumar_cuasifactura }
    end
  end

  # GET /liquidaciones_sumar_cuasifacturas/1/edit
  def edit
    @liquidacion_sumar_cuasifactura = LiquidacionSumarCuasifactura.find(params[:id])
  end

  # POST /liquidaciones_sumar_cuasifacturas
  # POST /liquidaciones_sumar_cuasifacturas.json
  def create
    @liquidacion_sumar_cuasifactura = LiquidacionSumarCuasifactura.new(params[:liquidacion_sumar_cuasifactura])

    respond_to do |format|
      if @liquidacion_sumar_cuasifactura.save
        format.html { redirect_to @liquidacion_sumar_cuasifactura, notice: 'Liquidacion sumar cuasifactura was successfully created.' }
        format.json { render json: @liquidacion_sumar_cuasifactura, status: :created, location: @liquidacion_sumar_cuasifactura }
      else
        format.html { render action: "new" }
        format.json { render json: @liquidacion_sumar_cuasifactura.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /liquidaciones_sumar_cuasifacturas/1
  # PUT /liquidaciones_sumar_cuasifacturas/1.json
  def update
    @liquidacion_sumar_cuasifactura = LiquidacionSumarCuasifactura.find(params[:id])

    respond_to do |format|
      if @liquidacion_sumar_cuasifactura.update_attributes(params[:liquidacion_sumar_cuasifactura])
        format.html { redirect_to @liquidacion_sumar_cuasifactura, notice: 'Liquidacion sumar cuasifactura was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @liquidacion_sumar_cuasifactura.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /liquidaciones_sumar_cuasifacturas/1
  # DELETE /liquidaciones_sumar_cuasifacturas/1.json
  def destroy
    @liquidacion_sumar_cuasifactura = LiquidacionSumarCuasifactura.find(params[:id])
    @liquidacion_sumar_cuasifactura.destroy

    respond_to do |format|
      format.html { redirect_to liquidaciones_sumar_cuasifacturas_url }
      format.json { head :no_content }
    end
  end
end
