# -*- encoding : utf-8 -*-
class NotasDeDebitoController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verificar_lectura
  before_filter :verificar_escritura, only: [:create, :new, :edit, :update]

  # GET /notas_de_debito
  def index
    @notas_de_debito = NotaDeDebito.all
  end

  # GET /notas_de_debito/1
  # GET /notas_de_debito/1.json
  def show
    @nota_de_debito = NotaDeDebito.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @nota_de_debito }
    end
  end

  # GET /notas_de_debito/new
  def new
    @nota_de_debito = NotaDeDebito.new
    @efectores = Efector.all.collect {|e| [e.nombre, e.id]}
    @conceptos_de_facturacion = ConceptoDeFacturacion.all.collect {|c| [c.concepto, c.id]}
    @tipos_de_notas = TipoDeNotaDebito.all.collect {|t| [t.nombre, t.id]}
  end

  # GET /notas_de_debito/1/edit
  def edit
    @nota_de_debito = NotaDeDebito.find(params[:id])
  end

  # POST /notas_de_debito
  def create
    @nota_de_debito = NotaDeDebito.new(params[:nota_de_debito])

    if @nota_de_debito.save
      redirect_to @nota_de_debito, :flash => { :tipo => :ok, :titulo => "Se creó la nota de debito N° #{@nota_de_debito.numero}" }
    else
      @efectores = Efector.all.collect {|e| [e.nombre, e.id]}
      @conceptos_de_facturacion = ConceptoDeFacturacion.all.collect {|c| [c.concepto, c.id]}
      @tipos_de_notas = TipoDeNotaDebito.all.collect {|t| [t.nombre, t.id]}
      
      render action: "new" 
    end
  end

  # PUT /notas_de_debito/1
  # PUT /notas_de_debito/1.json
  def update
    @nota_de_debito = NotaDeDebito.find(params[:id])

    respond_to do |format|
      if @nota_de_debito.update_attributes(params[:nota_de_debito])
        format.html { redirect_to @nota_de_debito, notice: 'Nota de debito was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @nota_de_debito.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notas_de_debito/1
  # DELETE /notas_de_debito/1.json
  def destroy
    @nota_de_debito = NotaDeDebito.find(params[:id])
    @nota_de_debito.destroy

    respond_to do |format|
      format.html { redirect_to notas_de_debito_url }
      format.json { head :no_content }
    end
  end

  private

  def verificar_lectura
    if cannot? :read, NotaDeDebito
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end

  def verificar_escritura
    if cannot? :manage, NotaDeDebito
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end

end
