class ExpedientesSumarController < ApplicationController
  # GET /expedientes_sumar
  # GET /expedientes_sumar.json
  def index
    @expedientes_sumar = ExpedienteSumar.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @expedientes_sumar }
    end
  end

  # GET /expedientes_sumar/1
  # GET /expedientes_sumar/1.json
  def show
    @expediente_sumar = ExpedienteSumar.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @expediente_sumar }
    end
  end

  # GET /expedientes_sumar/new
  # GET /expedientes_sumar/new.json
  def new
    @expediente_sumar = ExpedienteSumar.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @expediente_sumar }
    end
  end

  # GET /expedientes_sumar/1/edit
  def edit
    @expediente_sumar = ExpedienteSumar.find(params[:id])
  end

  # POST /expedientes_sumar
  # POST /expedientes_sumar.json
  def create
    @expediente_sumar = ExpedienteSumar.new(params[:expediente_sumar])

    respond_to do |format|
      if @expediente_sumar.save
        format.html { redirect_to @expediente_sumar, notice: 'Expediente sumar was successfully created.' }
        format.json { render json: @expediente_sumar, status: :created, location: @expediente_sumar }
      else
        format.html { render action: "new" }
        format.json { render json: @expediente_sumar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /expedientes_sumar/1
  # PUT /expedientes_sumar/1.json
  def update
    @expediente_sumar = ExpedienteSumar.find(params[:id])

    respond_to do |format|
      if @expediente_sumar.update_attributes(params[:expediente_sumar])
        format.html { redirect_to @expediente_sumar, notice: 'Expediente sumar was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @expediente_sumar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expedientes_sumar/1
  # DELETE /expedientes_sumar/1.json
  def destroy
    @expediente_sumar = ExpedienteSumar.find(params[:id])
    @expediente_sumar.destroy

    respond_to do |format|
      format.html { redirect_to expedientes_sumar_url }
      format.json { head :no_content }
    end
  end
end
