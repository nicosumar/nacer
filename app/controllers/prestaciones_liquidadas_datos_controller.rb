class PrestacionesLiquidadasDatosController < ApplicationController
  # GET /prestaciones_liquidadas_datos
  # GET /prestaciones_liquidadas_datos.json
  def index
    @prestaciones_liquidadas_datos = PrestacionLiquidadaDato.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @prestaciones_liquidadas_datos }
    end
  end

  # GET /prestaciones_liquidadas_datos/1
  # GET /prestaciones_liquidadas_datos/1.json
  def show
    @prestacion_liquidada_dato = PrestacionLiquidadaDato.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @prestacion_liquidada_dato }
    end
  end

  # GET /prestaciones_liquidadas_datos/new
  # GET /prestaciones_liquidadas_datos/new.json
  def new
    @prestacion_liquidada_dato = PrestacionLiquidadaDato.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @prestacion_liquidada_dato }
    end
  end

  # GET /prestaciones_liquidadas_datos/1/edit
  def edit
    @prestacion_liquidada_dato = PrestacionLiquidadaDato.find(params[:id])
  end

  # POST /prestaciones_liquidadas_datos
  # POST /prestaciones_liquidadas_datos.json
  def create
    @prestacion_liquidada_dato = PrestacionLiquidadaDato.new(params[:prestacion_liquidada_dato])

    respond_to do |format|
      if @prestacion_liquidada_dato.save
        format.html { redirect_to @prestacion_liquidada_dato, notice: 'Prestacion liquidada dato was successfully created.' }
        format.json { render json: @prestacion_liquidada_dato, status: :created, location: @prestacion_liquidada_dato }
      else
        format.html { render action: "new" }
        format.json { render json: @prestacion_liquidada_dato.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /prestaciones_liquidadas_datos/1
  # PUT /prestaciones_liquidadas_datos/1.json
  def update
    @prestacion_liquidada_dato = PrestacionLiquidadaDato.find(params[:id])

    respond_to do |format|
      if @prestacion_liquidada_dato.update_attributes(params[:prestacion_liquidada_dato])
        format.html { redirect_to @prestacion_liquidada_dato, notice: 'Prestacion liquidada dato was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @prestacion_liquidada_dato.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prestaciones_liquidadas_datos/1
  # DELETE /prestaciones_liquidadas_datos/1.json
  def destroy
    @prestacion_liquidada_dato = PrestacionLiquidadaDato.find(params[:id])
    @prestacion_liquidada_dato.destroy

    respond_to do |format|
      format.html { redirect_to prestaciones_liquidadas_datos_url }
      format.json { head :no_content }
    end
  end
end
