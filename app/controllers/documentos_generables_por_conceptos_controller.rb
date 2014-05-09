class DocumentosGenerablesPorConceptosController < ApplicationController
  # GET /documentos_generables_por_conceptos
  # GET /documentos_generables_por_conceptos.json
  def index
    @documentos_generables_por_conceptos = DocumentoGenerablePorConcepto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documentos_generables_por_conceptos }
    end
  end

  # GET /documentos_generables_por_conceptos/1
  # GET /documentos_generables_por_conceptos/1.json
  def show
    @documento_generable_por_concepto = DocumentoGenerablePorConcepto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @documento_generable_por_concepto }
    end
  end

  # GET /documentos_generables_por_conceptos/new
  # GET /documentos_generables_por_conceptos/new.json
  def new
    @documento_generable_por_concepto = DocumentoGenerablePorConcepto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @documento_generable_por_concepto }
    end
  end

  # GET /documentos_generables_por_conceptos/1/edit
  def edit
    @documento_generable_por_concepto = DocumentoGenerablePorConcepto.find(params[:id])
  end

  # POST /documentos_generables_por_conceptos
  # POST /documentos_generables_por_conceptos.json
  def create
    @documento_generable_por_concepto = DocumentoGenerablePorConcepto.new(params[:documento_generable_por_concepto])

    respond_to do |format|
      if @documento_generable_por_concepto.save
        format.html { redirect_to @documento_generable_por_concepto, notice: 'Documento generable por concepto was successfully created.' }
        format.json { render json: @documento_generable_por_concepto, status: :created, location: @documento_generable_por_concepto }
      else
        format.html { render action: "new" }
        format.json { render json: @documento_generable_por_concepto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /documentos_generables_por_conceptos/1
  # PUT /documentos_generables_por_conceptos/1.json
  def update
    @documento_generable_por_concepto = DocumentoGenerablePorConcepto.find(params[:id])

    respond_to do |format|
      if @documento_generable_por_concepto.update_attributes(params[:documento_generable_por_concepto])
        format.html { redirect_to @documento_generable_por_concepto, notice: 'Documento generable por concepto was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @documento_generable_por_concepto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documentos_generables_por_conceptos/1
  # DELETE /documentos_generables_por_conceptos/1.json
  def destroy
    @documento_generable_por_concepto = DocumentoGenerablePorConcepto.find(params[:id])
    @documento_generable_por_concepto.destroy

    respond_to do |format|
      format.html { redirect_to documentos_generables_por_conceptos_url }
      format.json { head :no_content }
    end
  end
end
