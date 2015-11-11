class PeriodosDeRendicionController < ApplicationController
  # GET /periodos_de_rendicion
  # GET /periodos_de_rendicion.json
  def index
    @periodos_de_rendicion = PeriodoDeRendicion.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @periodos_de_rendicion }
    end
  end

  # GET /periodos_de_rendicion/1
  # GET /periodos_de_rendicion/1.json
  def show
    @periodo_de_rendicion = PeriodoDeRendicion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @periodo_de_rendicion }
    end
  end

  # GET /periodos_de_rendicion/new
  # GET /periodos_de_rendicion/new.json
  def new
    @periodo_de_rendicion = PeriodoDeRendicion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @periodo_de_rendicion }
    end
  end

  # GET /periodos_de_rendicion/1/edit
  def edit
    @periodo_de_rendicion = PeriodoDeRendicion.find(params[:id])
  end

  # POST /periodos_de_rendicion
  # POST /periodos_de_rendicion.json
  def create
    @periodo_de_rendicion = PeriodoDeRendicion.new(params[:periodo_de_rendicion])

    respond_to do |format|
      if @periodo_de_rendicion.save
        format.html { redirect_to @periodo_de_rendicion, notice: 'Periodo de rendicion was successfully created.' }
        format.json { render json: @periodo_de_rendicion, status: :created, location: @periodo_de_rendicion }
      else
        format.html { render action: "new" }
        format.json { render json: @periodo_de_rendicion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /periodos_de_rendicion/1
  # PUT /periodos_de_rendicion/1.json
  def update
    @periodo_de_rendicion = PeriodoDeRendicion.find(params[:id])

    respond_to do |format|
      if @periodo_de_rendicion.update_attributes(params[:periodo_de_rendicion])
        format.html { redirect_to @periodo_de_rendicion, notice: 'Periodo de rendicion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @periodo_de_rendicion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /periodos_de_rendicion/1
  # DELETE /periodos_de_rendicion/1.json
  def destroy
    @periodo_de_rendicion = PeriodoDeRendicion.find(params[:id])
    @periodo_de_rendicion.destroy

    respond_to do |format|
      format.html { redirect_to periodos_de_rendicion_url }
      format.json { head :no_content }
    end
  end
end
