class AnexosMedicosPrestacionesController < ApplicationController
  # GET /anexos_medicos_prestaciones
  # GET /anexos_medicos_prestaciones.json
  def index
    @anexos_medicos_prestaciones = AnexoMedicoPrestacion.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @anexos_medicos_prestaciones }
    end
  end

  # GET /anexos_medicos_prestaciones/1
  # GET /anexos_medicos_prestaciones/1.json
  def show
    @anexo_medico_prestacion = AnexoMedicoPrestacion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @anexo_medico_prestacion }
    end
  end

  # GET /anexos_medicos_prestaciones/new
  # GET /anexos_medicos_prestaciones/new.json
  def new
    @anexo_medico_prestacion = AnexoMedicoPrestacion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @anexo_medico_prestacion }
    end
  end

  # GET /anexos_medicos_prestaciones/1/edit
  def edit
    @anexo_medico_prestacion = AnexoMedicoPrestacion.find(params[:id])
  end

  # POST /anexos_medicos_prestaciones
  # POST /anexos_medicos_prestaciones.json
  def create
    @anexo_medico_prestacion = AnexoMedicoPrestacion.new(params[:anexo_medico_prestacion])

    respond_to do |format|
      if @anexo_medico_prestacion.save
        format.html { redirect_to @anexo_medico_prestacion, notice: 'Anexo medico prestacion was successfully created.' }
        format.json { render json: @anexo_medico_prestacion, status: :created, location: @anexo_medico_prestacion }
      else
        format.html { render action: "new" }
        format.json { render json: @anexo_medico_prestacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /anexos_medicos_prestaciones/1
  # PUT /anexos_medicos_prestaciones/1.json
  def update
    @anexo_medico_prestacion = AnexoMedicoPrestacion.find(params[:id])

    respond_to do |format|
      if @anexo_medico_prestacion.update_attributes(params[:anexo_medico_prestacion])
        format.html { redirect_to @anexo_medico_prestacion, notice: 'Anexo medico prestacion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @anexo_medico_prestacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /anexos_medicos_prestaciones/1
  # DELETE /anexos_medicos_prestaciones/1.json
  def destroy
    @anexo_medico_prestacion = AnexoMedicoPrestacion.find(params[:id])
    @anexo_medico_prestacion.destroy

    respond_to do |format|
      format.html { redirect_to anexos_medicos_prestaciones_url }
      format.json { head :no_content }
    end
  end
end
