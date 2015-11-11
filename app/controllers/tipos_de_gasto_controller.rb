class TiposDeGastoController < ApplicationController
  # GET /tipos_de_gasto
  # GET /tipos_de_gasto.json
  def index
    @tipos_de_gasto = TipoDeGasto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tipos_de_gasto }
    end
  end

  # GET /tipos_de_gasto/1
  # GET /tipos_de_gasto/1.json
  def show
    @tipo_de_gasto = TipoDeGasto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tipo_de_gasto }
    end
  end

  # GET /tipos_de_gasto/new
  # GET /tipos_de_gasto/new.json
  def new
    @tipo_de_gasto = TipoDeGasto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tipo_de_gasto }
    end
  end

  # GET /tipos_de_gasto/1/edit
  def edit
    @tipo_de_gasto = TipoDeGasto.find(params[:id])
  end

  # POST /tipos_de_gasto
  # POST /tipos_de_gasto.json
  def create
    @tipo_de_gasto = TipoDeGasto.new(params[:tipo_de_gasto])

    respond_to do |format|
      if @tipo_de_gasto.save
        format.html { redirect_to @tipo_de_gasto, notice: 'Tipo de gasto was successfully created.' }
        format.json { render json: @tipo_de_gasto, status: :created, location: @tipo_de_gasto }
      else
        format.html { render action: "new" }
        format.json { render json: @tipo_de_gasto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tipos_de_gasto/1
  # PUT /tipos_de_gasto/1.json
  def update
    @tipo_de_gasto = TipoDeGasto.find(params[:id])

    respond_to do |format|
      if @tipo_de_gasto.update_attributes(params[:tipo_de_gasto])
        format.html { redirect_to @tipo_de_gasto, notice: 'Tipo de gasto was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tipo_de_gasto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipos_de_gasto/1
  # DELETE /tipos_de_gasto/1.json
  def destroy
    @tipo_de_gasto = TipoDeGasto.find(params[:id])
    @tipo_de_gasto.destroy

    respond_to do |format|
      format.html { redirect_to tipos_de_gasto_url }
      format.json { head :no_content }
    end
  end
end
