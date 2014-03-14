class DetallesDeDebitosPrestacionalesController < ApplicationController
  # GET /detalles_de_debitos_prestacionales
  # GET /detalles_de_debitos_prestacionales.json
  def index
    @detalles_de_debitos_prestacionales = DetalleDeDebitoPrestacional.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @detalles_de_debitos_prestacionales }
    end
  end

  # GET /detalles_de_debitos_prestacionales/1
  # GET /detalles_de_debitos_prestacionales/1.json
  def show
    @detalle_de_debito_prestacional = DetalleDeDebitoPrestacional.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @detalle_de_debito_prestacional }
    end
  end

  # GET /detalles_de_debitos_prestacionales/new
  # GET /detalles_de_debitos_prestacionales/new.json
  def new
    @detalle_de_debito_prestacional = DetalleDeDebitoPrestacional.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @detalle_de_debito_prestacional }
    end
  end

  # GET /detalles_de_debitos_prestacionales/1/edit
  def edit
    @detalle_de_debito_prestacional = DetalleDeDebitoPrestacional.find(params[:id])
  end

  # POST /detalles_de_debitos_prestacionales
  # POST /detalles_de_debitos_prestacionales.json
  def create
    @detalle_de_debito_prestacional = DetalleDeDebitoPrestacional.new(params[:detalle_de_debito_prestacional])

    respond_to do |format|
      if @detalle_de_debito_prestacional.save
        format.html { redirect_to @detalle_de_debito_prestacional, notice: 'Detalle de debito prestacional was successfully created.' }
        format.json { render json: @detalle_de_debito_prestacional, status: :created, location: @detalle_de_debito_prestacional }
      else
        format.html { render action: "new" }
        format.json { render json: @detalle_de_debito_prestacional.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /detalles_de_debitos_prestacionales/1
  # PUT /detalles_de_debitos_prestacionales/1.json
  def update
    @detalle_de_debito_prestacional = DetalleDeDebitoPrestacional.find(params[:id])

    respond_to do |format|
      if @detalle_de_debito_prestacional.update_attributes(params[:detalle_de_debito_prestacional])
        format.html { redirect_to @detalle_de_debito_prestacional, notice: 'Detalle de debito prestacional was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @detalle_de_debito_prestacional.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /detalles_de_debitos_prestacionales/1
  # DELETE /detalles_de_debitos_prestacionales/1.json
  def destroy
    @detalle_de_debito_prestacional = DetalleDeDebitoPrestacional.find(params[:id])
    @detalle_de_debito_prestacional.destroy

    respond_to do |format|
      format.html { redirect_to detalles_de_debitos_prestacionales_url }
      format.json { head :no_content }
    end
  end
end
