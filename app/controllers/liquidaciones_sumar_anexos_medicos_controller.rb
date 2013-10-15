class LiquidacionesSumarAnexosMedicosController < ApplicationController
  # GET /liquidaciones_sumar_anexos_medicos
  # GET /liquidaciones_sumar_anexos_medicos.json
  def index
    @liquidaciones_sumar_anexos_medicos = LiquidacionSumarAnexoMedico.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @liquidaciones_sumar_anexos_medicos }
    end
  end

  # GET /liquidaciones_sumar_anexos_medicos/1
  # GET /liquidaciones_sumar_anexos_medicos/1.json
  def show
    @liquidacion_sumar_anexo_medico = LiquidacionSumarAnexoMedico.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @liquidacion_sumar_anexo_medico }
    end
  end

  # GET /liquidaciones_sumar_anexos_medicos/new
  # GET /liquidaciones_sumar_anexos_medicos/new.json
  def new
    @liquidacion_sumar_anexo_medico = LiquidacionSumarAnexoMedico.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @liquidacion_sumar_anexo_medico }
    end
  end

  # GET /liquidaciones_sumar_anexos_medicos/1/edit
  def edit
    @liquidacion_sumar_anexo_medico = LiquidacionSumarAnexoMedico.find(params[:id])
  end

  # POST /liquidaciones_sumar_anexos_medicos
  # POST /liquidaciones_sumar_anexos_medicos.json
  def create
    @liquidacion_sumar_anexo_medico = LiquidacionSumarAnexoMedico.new(params[:liquidacion_sumar_anexo_medico])

    respond_to do |format|
      if @liquidacion_sumar_anexo_medico.save
        format.html { redirect_to @liquidacion_sumar_anexo_medico, notice: 'Liquidacion sumar anexo medico was successfully created.' }
        format.json { render json: @liquidacion_sumar_anexo_medico, status: :created, location: @liquidacion_sumar_anexo_medico }
      else
        format.html { render action: "new" }
        format.json { render json: @liquidacion_sumar_anexo_medico.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /liquidaciones_sumar_anexos_medicos/1
  # PUT /liquidaciones_sumar_anexos_medicos/1.json
  def update
    @liquidacion_sumar_anexo_medico = LiquidacionSumarAnexoMedico.find(params[:id])

    respond_to do |format|
      if @liquidacion_sumar_anexo_medico.update_attributes(params[:liquidacion_sumar_anexo_medico])
        format.html { redirect_to @liquidacion_sumar_anexo_medico, notice: 'Liquidacion sumar anexo medico was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @liquidacion_sumar_anexo_medico.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /liquidaciones_sumar_anexos_medicos/1
  # DELETE /liquidaciones_sumar_anexos_medicos/1.json
  def destroy
    @liquidacion_sumar_anexo_medico = LiquidacionSumarAnexoMedico.find(params[:id])
    @liquidacion_sumar_anexo_medico.destroy

    respond_to do |format|
      format.html { redirect_to liquidaciones_sumar_anexos_medicos_url }
      format.json { head :no_content }
    end
  end
end
