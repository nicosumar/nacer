class InformesDebitosPrestacionalesController < ApplicationController
  # GET /informes_debitos_prestacionales
  # GET /informes_debitos_prestacionales.json
  def index
    @informes_debitos_prestacionales = InformeDebitoPrestacional.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @informes_debitos_prestacionales }
    end
  end

  # GET /informes_debitos_prestacionales/1
  # GET /informes_debitos_prestacionales/1.json
  def show
    @inform_debito_prestacional = InformeDebitoPrestacional.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @inform_debito_prestacional }
    end
  end

  # GET /informes_debitos_prestacionales/new
  # GET /informes_debitos_prestacionales/new.json
  def new
    @inform_debito_prestacional = InformeDebitoPrestacional.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @inform_debito_prestacional }
    end
  end

  # GET /informes_debitos_prestacionales/1/edit
  def edit
    @inform_debito_prestacional = InformeDebitoPrestacional.find(params[:id])
  end

  # POST /informes_debitos_prestacionales
  # POST /informes_debitos_prestacionales.json
  def create
    @inform_debito_prestacional = InformeDebitoPrestacional.new(params[:inform_debito_prestacional])

    respond_to do |format|
      if @inform_debito_prestacional.save
        format.html { redirect_to @inform_debito_prestacional, notice: 'Informe debito prestacional was successfully created.' }
        format.json { render json: @inform_debito_prestacional, status: :created, location: @inform_debito_prestacional }
      else
        format.html { render action: "new" }
        format.json { render json: @inform_debito_prestacional.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /informes_debitos_prestacionales/1
  # PUT /informes_debitos_prestacionales/1.json
  def update
    @inform_debito_prestacional = InformeDebitoPrestacional.find(params[:id])

    respond_to do |format|
      if @inform_debito_prestacional.update_attributes(params[:inform_debito_prestacional])
        format.html { redirect_to @inform_debito_prestacional, notice: 'Informe debito prestacional was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @inform_debito_prestacional.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /informes_debitos_prestacionales/1
  # DELETE /informes_debitos_prestacionales/1.json
  def destroy
    @inform_debito_prestacional = InformeDebitoPrestacional.find(params[:id])
    @inform_debito_prestacional.destroy

    respond_to do |format|
      format.html { redirect_to informes_debitos_prestacionales_url }
      format.json { head :no_content }
    end
  end
end
