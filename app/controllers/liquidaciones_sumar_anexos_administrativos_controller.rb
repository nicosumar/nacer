class LiquidacionesSumarAnexosAdministrativosController < ApplicationController
  # GET /liquidaciones_sumar_anexos_administrativos
  # GET /liquidaciones_sumar_anexos_administrativos.json
  def index
    @liquidaciones_sumar_anexos_administrativos = LiquidacionSumarAnexoAdministrativo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @liquidaciones_sumar_anexos_administrativos }
    end
  end

  # GET /liquidaciones_sumar_anexos_administrativos/1
  # GET /liquidaciones_sumar_anexos_administrativos/1.json
  def show
    @liquidacion_sumar_anexo_administrativo = LiquidacionSumarAnexoAdministrativo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @liquidacion_sumar_anexo_administrativo }
    end
  end

  # GET /liquidaciones_sumar_anexos_administrativos/new
  # GET /liquidaciones_sumar_anexos_administrativos/new.json
  def new
    @liquidacion_sumar_anexo_administrativo = LiquidacionSumarAnexoAdministrativo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @liquidacion_sumar_anexo_administrativo }
    end
  end

  # GET /liquidaciones_sumar_anexos_administrativos/1/edit
  def edit
    @liquidacion_sumar_anexo_administrativo = LiquidacionSumarAnexoAdministrativo.find(params[:id])
  end

  # POST /liquidaciones_sumar_anexos_administrativos
  # POST /liquidaciones_sumar_anexos_administrativos.json
  def create
    @liquidacion_sumar_anexo_administrativo = LiquidacionSumarAnexoAdministrativo.new(params[:liquidacion_sumar_anexo_administrativo])

    respond_to do |format|
      if @liquidacion_sumar_anexo_administrativo.save
        format.html { redirect_to @liquidacion_sumar_anexo_administrativo, notice: 'Liquidacion sumar anexo administrativo was successfully created.' }
        format.json { render json: @liquidacion_sumar_anexo_administrativo, status: :created, location: @liquidacion_sumar_anexo_administrativo }
      else
        format.html { render action: "new" }
        format.json { render json: @liquidacion_sumar_anexo_administrativo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /liquidaciones_sumar_anexos_administrativos/1
  # PUT /liquidaciones_sumar_anexos_administrativos/1.json
  def update
    @liquidacion_sumar_anexo_administrativo = LiquidacionSumarAnexoAdministrativo.find(params[:id])

    respond_to do |format|
      if @liquidacion_sumar_anexo_administrativo.update_attributes(params[:liquidacion_sumar_anexo_administrativo])
        format.html { redirect_to @liquidacion_sumar_anexo_administrativo, notice: 'Liquidacion sumar anexo administrativo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @liquidacion_sumar_anexo_administrativo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /liquidaciones_sumar_anexos_administrativos/1
  # DELETE /liquidaciones_sumar_anexos_administrativos/1.json
  def destroy
    @liquidacion_sumar_anexo_administrativo = LiquidacionSumarAnexoAdministrativo.find(params[:id])
    @liquidacion_sumar_anexo_administrativo.destroy

    respond_to do |format|
      format.html { redirect_to liquidaciones_sumar_anexos_administrativos_url }
      format.json { head :no_content }
    end
  end
end
