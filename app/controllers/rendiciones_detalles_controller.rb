class RendicionesDetallesController < ApplicationController
  # GET /rendiciones_detalles
  # GET /rendiciones_detalles.json
  def index
    @rendiciones_detalles = RendicionDetalle.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rendiciones_detalles }
    end
  end

  # GET /rendiciones_detalles/1
  # GET /rendiciones_detalles/1.json
  def show
    @rendicion_detalle = RendicionDetalle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @rendicion_detalle }
    end
  end

  # GET /rendiciones_detalles/new
  # GET /rendiciones_detalles/new.json
  def new
    @rendicion_detalle = RendicionDetalle.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rendicion_detalle }
    end
  end

  # GET /rendiciones_detalles/1/edit
  def edit
    @rendicion_detalle = RendicionDetalle.find(params[:id])
  end

  # POST /rendiciones_detalles
  # POST /rendiciones_detalles.json
  def create
    @rendicion_detalle = RendicionDetalle.new(params[:rendicion_detalle])

    respond_to do |format|
      if @rendicion_detalle.save
        format.html { redirect_to @rendicion_detalle, notice: 'Rendicion detalle was successfully created.' }
        format.json { render json: @rendicion_detalle, status: :created, location: @rendicion_detalle }
      else
        format.html { render action: "new" }
        format.json { render json: @rendicion_detalle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rendiciones_detalles/1
  # PUT /rendiciones_detalles/1.json
  def update
    @rendicion_detalle = RendicionDetalle.find(params[:id])

    respond_to do |format|
      if @rendicion_detalle.update_attributes(params[:rendicion_detalle])
        format.html { redirect_to @rendicion_detalle, notice: 'Rendicion detalle was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @rendicion_detalle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rendiciones_detalles/1
  # DELETE /rendiciones_detalles/1.json
  def destroy
    @rendicion_detalle = RendicionDetalle.find(params[:id])
    @rendicion_detalle.destroy

    respond_to do |format|
      format.html { redirect_to rendiciones_detalles_url }
      format.json { head :no_content }
    end
  end
end
