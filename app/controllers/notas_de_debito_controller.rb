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
    @aplicaciones_de_notas_de_debito = @nota_de_debito.aplicaciones_de_notas_de_debito.includes(:pago_sumar).all
  end

  # GET /notas_de_debito/new
  def new
    @nota_de_debito = NotaDeDebito.new
    @efectores = Efector.all.collect {|e| [e.nombre, e.id]}
    @conceptos_de_facturacion = ConceptoDeFacturacion.all.collect {|c| [c.concepto, c.id]}
    @tipos_de_notas = TipoDeNotaDebito.where("codigo != 'DP'").collect {|t| [t.nombre, t.id]}
  end

  # GET /notas_de_debito/1/edit
  def edit
    @nota_de_debito = NotaDeDebito.find(params[:id])
    @efectores = Efector.all.collect {|e| [e.nombre, e.id]}
    @conceptos_de_facturacion = ConceptoDeFacturacion.all.collect {|c| [c.concepto, c.id]}
    @tipos_de_notas = TipoDeNotaDebito.where("codigo != 'DP'").collect {|t| [t.nombre, t.id]}
  end

  # POST /notas_de_debito
  def create
    @nota_de_debito = NotaDeDebito.new(params[:nota_de_debito])

    if @nota_de_debito.save
      redirect_to @nota_de_debito, :flash => { :tipo => :ok, :titulo => "Se creó la nota de debito" }
    else
      @efectores = Efector.all.collect {|e| [e.nombre, e.id]}
      @conceptos_de_facturacion = ConceptoDeFacturacion.all.collect {|c| [c.concepto, c.id]}
      @tipos_de_notas = TipoDeNotaDebito.where("codigo != 'DP'").collect {|t| [t.nombre, t.id]}
      
      render action: "new" 
    end
  end

  # PUT /notas_de_debito/1
  def update
    @nota_de_debito = NotaDeDebito.find(params[:id])

    if @nota_de_debito.update_attributes(params[:nota_de_debito])
      redirect_to @nota_de_debito, :flash => { :tipo => :ok, :titulo => "Se actualizó la nota de debito" }
    else
      @efectores = Efector.all.collect {|e| [e.nombre, e.id]}
      @conceptos_de_facturacion = ConceptoDeFacturacion.all.collect {|c| [c.concepto, c.id]}
      @tipos_de_notas = TipoDeNotaDebito.all.collect {|t| [t.nombre, t.id]}

      render action: "edit" 
    end
  end

  # GET /notas_de_debito/remanentes_por_efector
  def remanentes_por_efector
    begin
      cadena = params[:q]
      x = params[:page]
      y = params[:per]

      efector = Efector.find(params[:parametros_adicionales][:pago_sumar_efector_id])
      concepto = ConceptoDeFacturacion.find(params[:parametros_adicionales][:pago_sumar_concepto_de_facturacion_id])

      @notas_de_debito = NotaDeDebito.disponibles_para_aplicacion
                                     .por_efector(efector, true)
                                     .where(concepto_de_facturacion_id: concepto)
                                     .where("notas_de_debito.numero ilike ?", "%#{cadena}%")
                                     .includes(:tipo_de_nota_debito)
    
      @notas_de_debito.map! do |nd|
        {
          id: nd.id,
          numero: nd.numero,
          tipo_nombre: nd.tipo_de_nota_debito.nombre,
          tipo_codigo: nd.tipo_de_nota_debito.codigo,
          monto_original: nd.monto,
          monto_remanente: nd.remanente,
          monto_reservado: nd.reservado,
          monto_disponible: nd.remanente - nd.reservado
        }
      end

      respond_to do |format|
          format.json {
            render json: {total: @notas_de_debito.size ,notas_de_debito: @notas_de_debito }
          }
      end

    rescue Exception => e
      respond_to do |format|
        format.json {
          render json: {total: 0, notas_de_debito: [] }, status: :ok
        }
      end #end response
    end #end begin rescue    
  end # end pendientes_por_efector

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
