class LiquidacionesSumarController < ApplicationController
  # GET /liquidaciones_sumar
  # GET /liquidaciones_sumar.json
  def index
    @liquidaciones_sumar = LiquidacionSumar.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @liquidaciones_sumar }
    end
  end

  # GET /liquidaciones_sumar/1
  # GET /liquidaciones_sumar/1.json
  def show
    @liquidacion_sumar = LiquidacionSumar.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @liquidacion_sumar }
    end
  end

  # GET /liquidaciones_sumar/new
  # GET /liquidaciones_sumar/new.json
  def new
    @liquidacion_sumar = LiquidacionSumar.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @liquidacion_sumar }
    end
  end

  # GET /liquidaciones_sumar/1/edit
  def edit
    @liquidacion_sumar = LiquidacionSumar.find(params[:id])
  end

  # POST /liquidaciones_sumar
  # POST /liquidaciones_sumar.json
  def create
    @liquidacion_sumar = LiquidacionSumar.new(params[:liquidacion_sumar])

    respond_to do |format|
      if @liquidacion_sumar.save
        format.html { redirect_to @liquidacion_sumar, notice: 'Liquidacion sumar was successfully created.' }
        format.json { render json: @liquidacion_sumar, status: :created, location: @liquidacion_sumar }
      else
        format.html { render action: "new" }
        format.json { render json: @liquidacion_sumar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /liquidaciones_sumar/1
  # PUT /liquidaciones_sumar/1.json
  def update
    @liquidacion_sumar = LiquidacionSumar.find(params[:id])

    respond_to do |format|
      if @liquidacion_sumar.update_attributes(params[:liquidacion_sumar])
        format.html { redirect_to @liquidacion_sumar, notice: 'Liquidacion sumar was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @liquidacion_sumar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /liquidaciones_sumar/1
  # DELETE /liquidaciones_sumar/1.json
  def destroy
    @liquidacion_sumar = LiquidacionSumar.find(params[:id])
    @liquidacion_sumar.destroy

    respond_to do |format|
      format.html { redirect_to liquidaciones_sumar_url }
      format.json { head :no_content }
    end
  end
end
