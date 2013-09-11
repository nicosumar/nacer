class PrestacionesIncluidasController < ApplicationController
  # GET /prestaciones_incluidas
  # GET /prestaciones_incluidas.json
  def index
    @prestaciones_incluidas = PrestacionIncluida.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @prestaciones_incluidas }
    end
  end

  # GET /prestaciones_incluidas/1
  # GET /prestaciones_incluidas/1.json
  def show
    @prestacion_incluida = PrestacionIncluida.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @prestacion_incluida }
    end
  end

  # GET /prestaciones_incluidas/new
  # GET /prestaciones_incluidas/new.json
  def new
    @prestacion_incluida = PrestacionIncluida.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @prestacion_incluida }
    end
  end

  # GET /prestaciones_incluidas/1/edit
  def edit
    @prestacion_incluida = PrestacionIncluida.find(params[:id])
  end

  # POST /prestaciones_incluidas
  # POST /prestaciones_incluidas.json
  def create
    @prestacion_incluida = PrestacionIncluida.new(params[:prestacion_incluida])

    respond_to do |format|
      if @prestacion_incluida.save
        format.html { redirect_to @prestacion_incluida, notice: 'Prestacion incluida was successfully created.' }
        format.json { render json: @prestacion_incluida, status: :created, location: @prestacion_incluida }
      else
        format.html { render action: "new" }
        format.json { render json: @prestacion_incluida.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /prestaciones_incluidas/1
  # PUT /prestaciones_incluidas/1.json
  def update
    @prestacion_incluida = PrestacionIncluida.find(params[:id])

    respond_to do |format|
      if @prestacion_incluida.update_attributes(params[:prestacion_incluida])
        format.html { redirect_to @prestacion_incluida, notice: 'Prestacion incluida was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @prestacion_incluida.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prestaciones_incluidas/1
  # DELETE /prestaciones_incluidas/1.json
  def destroy
    @prestacion_incluida = PrestacionIncluida.find(params[:id])
    @prestacion_incluida.destroy

    respond_to do |format|
      format.html { redirect_to prestaciones_incluidas_url }
      format.json { head :no_content }
    end
  end
end
