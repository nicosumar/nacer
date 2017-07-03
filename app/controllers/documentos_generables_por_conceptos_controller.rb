# -*- encoding : utf-8 -*-
class DocumentosGenerablesPorConceptosController < ApplicationController
  before_filter :get_concepto_de_facturacion
  before_filter :authenticate_user!
  before_filter :verificar_lectura
  before_filter :verificar_creacion, only: [:create]

  # GET /documentos_generables_por_conceptos
  def index
    @documentos_generables_por_conceptos = @concepto_de_facturacion.documentos_generables_por_conceptos.includes(:documento_generable, :tipo_de_agrupacion).order(:orden)
    @documentos_generables = DocumentoGenerable.all.collect {|d| [d.nombre, d.id]}
    @tipos_de_agrupacion = TipoDeAgrupacion.all.collect {|t| [t.nombre, t.id]}
    @documento_generable_por_concepto = DocumentoGenerablePorConcepto.new
  end

  # POST /documentos_generables_por_conceptos.js
  def create
    @documento_generable_por_concepto = @concepto_de_facturacion.documentos_generables_por_conceptos.new(params[:documento_generable_por_concepto])

    respond_to do |format|
      begin
        @documento_generable_por_concepto.save!
      rescue ActiveRecord::RecordNotUnique => e
        if e.message.include? "concepto_de_facturacion_id, documento_generable_id"
          @documento_generable_por_concepto.errors.add(:duplicado, "El documento generable ya fue elegido para este concepto.")
        end
        if e.message.include? "concepto_de_facturacion_id, orden"
          @documento_generable_por_concepto.errors.add(:duplicado2, "Otro documento ya esta elegido para ser generado en ese orden.")
        end
      rescue Exception => e
        @documento_generable_por_concepto.errors.add(:otro, e.message)
      end
      format.js
    end
  end

  def destroy
    @documento_generable_por_concepto = DocumentoGenerablePorConcepto.find(params[:id])
    @documento_generable_por_concepto.destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def get_concepto_de_facturacion
    
    begin
      @concepto_de_facturacion = ConceptoDeFacturacion.find(params[:concepto_de_facturacion_id])
    rescue Exception => e
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})  
    end
  end

  def verificar_lectura
    if cannot? :read, DocumentoGenerablePorConcepto
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end

  def verificar_creacion
    if cannot? :create, DocumentoGenerablePorConcepto
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end
end
