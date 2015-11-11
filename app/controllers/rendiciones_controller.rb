# -*- encoding : utf-8 -*-
class RendicionesController < ApplicationController
  before_filter :cargar_selects, :only => [:show, :new, :edit]

  # GET /rendiciones
  # GET /rendiciones.json
  def index
    @rendiciones = Rendicion.all
  end

  # GET /rendiciones/1 
  # GET /rendiciones/1.json
  def show
    @rendicion = Rendicion.find(params[:id])
    @rendiciones_detalles = @rendicion.rendiciones_detalles.where(id: params[:id])
  end

  # GET /rendiciones/new
  # GET /rendiciones/new.json
  def new
    @rendicion = Rendicion.new
    @rendicion.rendiciones_detalles.build
  end

  # GET /rendiciones/1/edit
  def edit
    @rendicion = Rendicion.find(params[:id])
  end

  # POST /rendiciones
  # POST /rendiciones.json
  def create
    @rendicion = Rendicion.new(params[:rendicion])
    #validacion de la existencia del registro del efector para el pediodo
 
    if @rendicion.save
      redirect_to @rendicion, notice: 'La rendicion y su detalle fueron guardados con exito.' 
    else
      @efectores = Efector.all.map { |ef| [ef.nombre, ef.id]}          
      @periodos_de_rendicion = PeriodoDeRendicion.all.map {|pr| [pr.nombre, pr.id]}
      @tipos_de_gasto = TipoDeGasto.all.map {|tg| [tg.nombre, tg.id]}
      render action: "new" 
    end
  end

  # PUT /rendiciones/1
  # PUT /rendiciones/1.json
  def update
    @rendicion = Rendicion.find(params[:id])

    respond_to do |format|
      if @rendicion.update_attributes(params[:rendicion])
        format.html { redirect_to @rendicion, notice: 'Rendicion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @rendicion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rendiciones/1
  # DELETE /rendiciones/1.json
  def destroy
    @rendicion = Rendicion.find(params[:id])
    @rendicion.destroy

    respond_to do |format|
      format.html { redirect_to rendiciones_url }
      format.json { head :no_content }
    end
  end

  def actualizar_estado
   # @estado_de_rendicion = EstadoDeRendicion.all.map do |er|
   #   [er.nombre, er.id]
   # end
   #      @efectores = Efector.all.map do |ef|
   #   [ef.nombre, ef.id]
   # end   
   # @periodos_de_rendicion = PeriodoDeRendicion.all.map do |pr|
   #   [pr.nombre, pr.id]
   # end

   @estado_de_rendicion = EstadoDeRendicion.all.map do |er|
      [er.nombre, er.id]
   end
   # @tipos_de_gasto = TipoDeGasto.all.map do |tg|
   #   [tg.nombre, tg.id]
   # end
    @rendicion = Rendicion.find(params[:id])
    @rendiciones_detalles = @rendicion.rendiciones_detalles.where(id: params[:id])
    #@rendicion.estado_de_rendicion_id = 1
    @rendicion.save!
  end

  def imprimir
    @rendicion = Rendicion.find(params[:id])
    @rendicion_detalle = @rendicion.rendiciones_detalles.where(id: params[:id])
    # Armar el reporte
      reporte = ODFReport::Report.new("lib/assets/informe_rendicion.odt") do |r|
        r.add_field :efector,             @rendicion.efector.nombre
        r.add_field :departamento,        @rendicion.efector.departamento.nombre
        r.add_field :banco,               @rendicion.efector.banco_cuenta_principal
        r.add_field :ctacte,              @rendicion.efector.numero_de_cuenta_principal
        r.add_field :cuit,                @rendicion.efector.cuit
        r.add_field :periodo,             @rendicion.periodo_de_rendicion.nombre
        r.add_table("FIELDS", @rendicion.rendiciones_detalles, :header=>true) do |t|
          t.add_column(:fecha) { |rendicion_detalle|  "#{rendicion_detalle.fecha}" }
          t.add_column(:detalle) { |rendicion_detalle| "#{rendicion_detalle.detalle}" }
          t.add_column(:cantidad) { |rendicion_detalle| "#{rendicion_detalle.cant}" }
          t.add_column(:numero) { |rendicion_detalle| "#{rendicion_detalle.nro_factura}" }
          t.add_column(:cheque) { |rendicion_detalle| "#{rendicion_detalle.nro_cheque}" }
          t.add_column(:importe) { |rendicion_detalle| "$#{rendicion_detalle.importe_gasto}" }
          t.add_column(:bien) { |rendicion_detalle| "#{rendicion_detalle.tipo_de_gasto.nombre}" }
        #  @total += rendicion_detalle.importe_gasto
        end
        r.add_field :total,      "$#{@rendicion.rendiciones_detalles.sum('importe_gasto')}"
      end
      nombre_archivo = Cocaine::CommandLine.new("mktemp", "--tmpdir=tmp/ -u report_XXXXXXXXXX").run.chomp
      reporte.generate(nombre_archivo + ".odt")
      Cocaine::CommandLine.new("unoconv", "-f pdf -e EnableCopyingOfContent -e ExportFormFields -e FormsType=FDF #{nombre_archivo}.odt").run
      send_file "#{nombre_archivo}.pdf", type: 'application/pdf', disposition: 'attachment'
   
  end


  def cargar_selects
     @efectores = Efector.all.map do |ef|
      [ef.nombre, ef.id]
    end   
    @periodos_de_rendicion = PeriodoDeRendicion.all.map do |pr|
      [pr.nombre, pr.id]
    end
    @estado_de_rendicion = EstadoDeRendicion.all.map do |er|
      [er.nombre, er.id]
    end
    @tipos_de_gasto = TipoDeGasto.all.map do |tg|
      [tg.nombre, tg.id]
    end
  end

end
