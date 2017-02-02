class DocumentosGenerablesController < ApplicationController
  # GET /documentos_generables
  # GET /documentos_generables.json
  def index
    @documentos_generables = DocumentoGenerable.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documentos_generables }
    end
  end

  # GET /documentos_generables/1
  # GET /documentos_generables/1.json
  def show
    @documento_generable = DocumentoGenerable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @documento_generable }
    end
  end

  # GET /documentos_generables/new
  # GET /documentos_generables/new.json
  def new
    @documento_generable = DocumentoGenerable.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @documento_generable }
    end
  end

  # GET /documentos_generables/1/edit
  def edit
    @documento_generable = DocumentoGenerable.find(params[:id])
  end

  # POST /documentos_generables
  # POST /documentos_generables.json
  def create
    @documento_generable = DocumentoGenerable.new(params[:documento_generable])

    respond_to do |format|
      if @documento_generable.save
        format.html { redirect_to @documento_generable, notice: 'Documento generable was successfully created.' }
        format.json { render json: @documento_generable, status: :created, location: @documento_generable }
      else
        format.html { render action: "new" }
        format.json { render json: @documento_generable.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /documentos_generables/1
  # PUT /documentos_generables/1.json
  def update
    @documento_generable = DocumentoGenerable.find(params[:id])

    respond_to do |format|
      if @documento_generable.update_attributes(params[:documento_generable])
        format.html { redirect_to @documento_generable, notice: 'Documento generable was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @documento_generable.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documentos_generables/1
  # DELETE /documentos_generables/1.json
  def destroy
    @documento_generable = DocumentoGenerable.find(params[:id])
    @documento_generable.destroy

    respond_to do |format|
      format.html { redirect_to documentos_generables_url }
      format.json { head :no_content }
    end
  end
end
