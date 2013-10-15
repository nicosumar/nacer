class AnexosAdministrativosPrestacionesController < ApplicationController
  # GET /anexos_administrativos_prestaciones
  # GET /anexos_administrativos_prestaciones.json
  def index
    @anexos_administrativos_prestaciones = AnexoAdministrativoPrestacion.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @anexos_administrativos_prestaciones }
    end
  end

  # GET /anexos_administrativos_prestaciones/1
  # GET /anexos_administrativos_prestaciones/1.json
  def show
    @anexo_administrativo_prestacion = AnexoAdministrativoPrestacion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @anexo_administrativo_prestacion }
    end
  end

  # GET /anexos_administrativos_prestaciones/new
  # GET /anexos_administrativos_prestaciones/new.json
  def new
    @anexo_administrativo_prestacion = AnexoAdministrativoPrestacion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @anexo_administrativo_prestacion }
    end
  end

  # GET /anexos_administrativos_prestaciones/1/edit
  def edit
    @anexo_administrativo_prestacion = AnexoAdministrativoPrestacion.find(params[:id])
  end

  # POST /anexos_administrativos_prestaciones
  # POST /anexos_administrativos_prestaciones.json
  def create
    @anexo_administrativo_prestacion = AnexoAdministrativoPrestacion.new(params[:anexo_administrativo_prestacion])

    respond_to do |format|
      if @anexo_administrativo_prestacion.save
        format.html { redirect_to @anexo_administrativo_prestacion, notice: 'Anexo administrativo prestacion was successfully created.' }
        format.json { render json: @anexo_administrativo_prestacion, status: :created, location: @anexo_administrativo_prestacion }
      else
        format.html { render action: "new" }
        format.json { render json: @anexo_administrativo_prestacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /anexos_administrativos_prestaciones/1
  # PUT /anexos_administrativos_prestaciones/1.json
  def update
    @anexo_administrativo_prestacion = AnexoAdministrativoPrestacion.find(params[:id])

    respond_to do |format|
      if @anexo_administrativo_prestacion.update_attributes(params[:anexo_administrativo_prestacion])
        format.html { redirect_to @anexo_administrativo_prestacion, notice: 'Anexo administrativo prestacion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @anexo_administrativo_prestacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /anexos_administrativos_prestaciones/1
  # DELETE /anexos_administrativos_prestaciones/1.json
  def destroy
    @anexo_administrativo_prestacion = AnexoAdministrativoPrestacion.find(params[:id])
    @anexo_administrativo_prestacion.destroy

    respond_to do |format|
      format.html { redirect_to anexos_administrativos_prestaciones_url }
      format.json { head :no_content }
    end
  end
end
