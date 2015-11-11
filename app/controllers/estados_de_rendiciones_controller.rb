class EstadosDeRendicionesController < ApplicationController
  # GET /estados_de_rendiciones
  # GET /estados_de_rendiciones.json
  def index
    @estados_de_rendiciones = EstadoDeRendicion.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @estados_de_rendiciones }
    end
  end

  # GET /estados_de_rendiciones/1
  # GET /estados_de_rendiciones/1.json
  def show
    @estado_de_rendicion = EstadoDeRendicion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @estado_de_rendicion }
    end
  end

  # GET /estados_de_rendiciones/new
  # GET /estados_de_rendiciones/new.json
  def new
    @estado_de_rendicion = EstadoDeRendicion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @estado_de_rendicion }
    end
  end

  # GET /estados_de_rendiciones/1/edit
  def edit
    @estado_de_rendicion = EstadoDeRendicion.find(params[:id])
  end

  # POST /estados_de_rendiciones
  # POST /estados_de_rendiciones.json
  def create
    @estado_de_rendicion = EstadoDeRendicion.new(params[:estado_de_rendicion])

    respond_to do |format|
      if @estado_de_rendicion.save
        format.html { redirect_to @estado_de_rendicion, notice: 'Estado de rendicion was successfully created.' }
        format.json { render json: @estado_de_rendicion, status: :created, location: @estado_de_rendicion }
      else
        format.html { render action: "new" }
        format.json { render json: @estado_de_rendicion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /estados_de_rendiciones/1
  # PUT /estados_de_rendiciones/1.json
  def update
    @estado_de_rendicion = EstadoDeRendicion.find(params[:id])

    respond_to do |format|
      if @estado_de_rendicion.update_attributes(params[:estado_de_rendicion])
        format.html { redirect_to @estado_de_rendicion, notice: 'Estado de rendicion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @estado_de_rendicion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /estados_de_rendiciones/1
  # DELETE /estados_de_rendiciones/1.json
  def destroy
    @estado_de_rendicion = EstadoDeRendicion.find(params[:id])
    @estado_de_rendicion.destroy

    respond_to do |format|
      format.html { redirect_to estados_de_rendiciones_url }
      format.json { head :no_content }
    end
  end
end
