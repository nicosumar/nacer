class PrestacionesLiquidadasController < ApplicationController
  # GET /prestaciones_liquidadas
  # GET /prestaciones_liquidadas.json
  def index
    @prestaciones_liquidadas = PrestacionLiquidada.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @prestaciones_liquidadas }
    end
  end

  # GET /prestaciones_liquidadas/1
  # GET /prestaciones_liquidadas/1.json
  def show
    @prestacion_liquidada = PrestacionLiquidada.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @prestacion_liquidada }
    end
  end

  # GET /prestaciones_liquidadas/new
  # GET /prestaciones_liquidadas/new.json
  def new
    @prestacion_liquidada = PrestacionLiquidada.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @prestacion_liquidada }
    end
  end

  # GET /prestaciones_liquidadas/1/edit
  def edit
    @prestacion_liquidada = PrestacionLiquidada.find(params[:id])
  end

  # POST /prestaciones_liquidadas
  # POST /prestaciones_liquidadas.json
  def create
    @prestacion_liquidada = PrestacionLiquidada.new(params[:prestacion_liquidada])

    respond_to do |format|
      if @prestacion_liquidada.save
        format.html { redirect_to @prestacion_liquidada, notice: 'Prestacion liquidada was successfully created.' }
        format.json { render json: @prestacion_liquidada, status: :created, location: @prestacion_liquidada }
      else
        format.html { render action: "new" }
        format.json { render json: @prestacion_liquidada.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /prestaciones_liquidadas/1
  # PUT /prestaciones_liquidadas/1.json
  def update
    @prestacion_liquidada = PrestacionLiquidada.find(params[:id])

    respond_to do |format|
      if @prestacion_liquidada.update_attributes(params[:prestacion_liquidada])
        format.html { redirect_to @prestacion_liquidada, notice: 'Prestacion liquidada was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @prestacion_liquidada.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prestaciones_liquidadas/1
  # DELETE /prestaciones_liquidadas/1.json
  def destroy
    @prestacion_liquidada = PrestacionLiquidada.find(params[:id])
    @prestacion_liquidada.destroy

    respond_to do |format|
      format.html { redirect_to prestaciones_liquidadas_url }
      format.json { head :no_content }
    end
  end
end
