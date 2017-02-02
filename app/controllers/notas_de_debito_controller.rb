# -*- encoding : utf-8 -*-
class NotasDeDebitoController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verificar_lectura
  before_filter :verificar_escritura, only: [:create, :new, :edit, :update]

  # GET /notas_de_debito
  def index
    @notas_de_debito = NotaDeDebito.includes(:efector, :tipo_de_nota_debito, :concepto_de_facturacion).all
  end

  # GET /notas_de_debito/1
  def show
    @nota_de_debito = NotaDeDebito.includes(:efector, :tipo_de_nota_debito, :concepto_de_facturacion).find(params[:id])
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
    @efectores = Efector.all.collect {|e| [e.nombre, e.id]}
    @conceptos_de_facturacion = ConceptoDeFacturacion.all.collect {|c| [c.concepto, c.id]}
    @tipos_de_notas = TipoDeNotaDebito.all.collect {|t| [t.nombre, t.id]}
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
  def update
    @nota_de_debito = NotaDeDebito.find(params[:id])

    if @nota_de_debito.update_attributes(params[:nota_de_debito])
      redirect_to @nota_de_debito, :flash => { :tipo => :ok, :titulo => "Se actualizó la nota de debito N° #{@nota_de_debito.numero}" }
    else
      @efectores = Efector.all.collect {|e| [e.nombre, e.id]}
      @conceptos_de_facturacion = ConceptoDeFacturacion.all.collect {|c| [c.concepto, c.id]}
      @tipos_de_notas = TipoDeNotaDebito.all.collect {|t| [t.nombre, t.id]}

      render action: "edit" 
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
