class ParametrosLiquidacionesSumarController < ApplicationController
  # GET /parametros_liquidaciones_sumar
  # GET /parametros_liquidaciones_sumar.json
  def index
    @parametros_liquidaciones_sumar = ParametroLiquidacionSumar.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @parametros_liquidaciones_sumar }
    end
  end

  # GET /parametros_liquidaciones_sumar/1
  # GET /parametros_liquidaciones_sumar/1.json
  def show
    @parametro_liquidacion_sumar = ParametroLiquidacionSumar.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @parametro_liquidacion_sumar }
    end
  end

  # GET /parametros_liquidaciones_sumar/new
  # GET /parametros_liquidaciones_sumar/new.json
  def new
    @parametro_liquidacion_sumar = ParametroLiquidacionSumar.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @parametro_liquidacion_sumar }
    end
  end

  # GET /parametros_liquidaciones_sumar/1/edit
  def edit
    @parametro_liquidacion_sumar = ParametroLiquidacionSumar.find(params[:id])
  end

  # POST /parametros_liquidaciones_sumar
  # POST /parametros_liquidaciones_sumar.json
  def create
    @parametro_liquidacion_sumar = ParametroLiquidacionSumar.new(params[:parametro_liquidacion_sumar])

    respond_to do |format|
      if @parametro_liquidacion_sumar.save
        format.html { redirect_to @parametro_liquidacion_sumar, notice: 'Parametro liquidacion sumar was successfully created.' }
        format.json { render json: @parametro_liquidacion_sumar, status: :created, location: @parametro_liquidacion_sumar }
      else
        format.html { render action: "new" }
        format.json { render json: @parametro_liquidacion_sumar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /parametros_liquidaciones_sumar/1
  # PUT /parametros_liquidaciones_sumar/1.json
  def update
    @parametro_liquidacion_sumar = ParametroLiquidacionSumar.find(params[:id])

    respond_to do |format|
      if @parametro_liquidacion_sumar.update_attributes(params[:parametro_liquidacion_sumar])
        format.html { redirect_to @parametro_liquidacion_sumar, notice: 'Parametro liquidacion sumar was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @parametro_liquidacion_sumar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parametros_liquidaciones_sumar/1
  # DELETE /parametros_liquidaciones_sumar/1.json
  def destroy
    @parametro_liquidacion_sumar = ParametroLiquidacionSumar.find(params[:id])
    @parametro_liquidacion_sumar.destroy

    respond_to do |format|
      format.html { redirect_to parametros_liquidaciones_sumar_url }
      format.json { head :no_content }
    end
  end
end
