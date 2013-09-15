class PrestacionesLiquidadasAdvertenciasController < ApplicationController
  # GET /prestaciones_liquidadas_advertencias
  # GET /prestaciones_liquidadas_advertencias.json
  def index
    @prestaciones_liquidadas_advertencias = PrestacionLiquidadaAdvertencia.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @prestaciones_liquidadas_advertencias }
    end
  end

  # GET /prestaciones_liquidadas_advertencias/1
  # GET /prestaciones_liquidadas_advertencias/1.json
  def show
    @prestacion_liquidada_advertencia = PrestacionLiquidadaAdvertencia.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @prestacion_liquidada_advertencia }
    end
  end

  # GET /prestaciones_liquidadas_advertencias/new
  # GET /prestaciones_liquidadas_advertencias/new.json
  def new
    @prestacion_liquidada_advertencia = PrestacionLiquidadaAdvertencia.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @prestacion_liquidada_advertencia }
    end
  end

  # GET /prestaciones_liquidadas_advertencias/1/edit
  def edit
    @prestacion_liquidada_advertencia = PrestacionLiquidadaAdvertencia.find(params[:id])
  end

  # POST /prestaciones_liquidadas_advertencias
  # POST /prestaciones_liquidadas_advertencias.json
  def create
    @prestacion_liquidada_advertencia = PrestacionLiquidadaAdvertencia.new(params[:prestacion_liquidada_advertencia])

    respond_to do |format|
      if @prestacion_liquidada_advertencia.save
        format.html { redirect_to @prestacion_liquidada_advertencia, notice: 'Prestacion liquidada advertencia was successfully created.' }
        format.json { render json: @prestacion_liquidada_advertencia, status: :created, location: @prestacion_liquidada_advertencia }
      else
        format.html { render action: "new" }
        format.json { render json: @prestacion_liquidada_advertencia.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /prestaciones_liquidadas_advertencias/1
  # PUT /prestaciones_liquidadas_advertencias/1.json
  def update
    @prestacion_liquidada_advertencia = PrestacionLiquidadaAdvertencia.find(params[:id])

    respond_to do |format|
      if @prestacion_liquidada_advertencia.update_attributes(params[:prestacion_liquidada_advertencia])
        format.html { redirect_to @prestacion_liquidada_advertencia, notice: 'Prestacion liquidada advertencia was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @prestacion_liquidada_advertencia.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prestaciones_liquidadas_advertencias/1
  # DELETE /prestaciones_liquidadas_advertencias/1.json
  def destroy
    @prestacion_liquidada_advertencia = PrestacionLiquidadaAdvertencia.find(params[:id])
    @prestacion_liquidada_advertencia.destroy

    respond_to do |format|
      format.html { redirect_to prestaciones_liquidadas_advertencias_url }
      format.json { head :no_content }
    end
  end
end
