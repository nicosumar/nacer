# -*- encoding : utf-8 -*-
class CuentasBancariasController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :verificar_permisos

  # GET /cuentas_bancarias
  def index
    @cuentas_bancarias = CuentaBancaria.includes(:banco, :entidad, :tipo_de_cuenta_bancaria, :sucursal_bancaria ).all
  end

  # GET /cuentas_bancarias/1
  def show
    @cuenta_bancaria = CuentaBancaria.find(params[:id])
  end

  # GET /cuentas_bancarias/new
  def new
    @cuenta_bancaria = CuentaBancaria.new

    # Datos para selects 
    # Entidades
    @tipos_de_entidades = Entidad.select("DISTINCT entidad_type").collect {|t| [t.entidad_type.underscore.humanize, t.entidad_type]}
    @entidades = Entidad.select("DISTINCT entidad_type").collect do |ent|
      Entidad.where(entidad_type: ent.entidad_type).includes(:entidad).collect do |e|
        [e.entidad.nombre, e.id, {class: ent.entidad_type}]
      end
    end.flatten!(1).uniq

    # Bancos
    @bancos = Banco.all.collect {|b| [b.nombre, b.id]}
    @sucursales_bancarias = Banco.all.collect do |b|
      b.sucursales_bancarias.collect do |s|
        [
          s.nombre.present? ? s.numero + "- " + s.nombre : s.numero , 
          s.id, 
          {class: b.id}
        ]
      end
    end.flatten(1).uniq

    @tipos_de_cuentas = TipoDeCuentaBancaria.all.collect {|t| [t.nombre, t.id]}
  end

  # GET /cuentas_bancarias/1/edit
  def edit
    @cuenta_bancaria = CuentaBancaria.find(params[:id])

    # Datos para selects 
    # Entidades
    @tipos_de_entidades = Entidad.select("DISTINCT entidad_type").collect {|t| [t.entidad_type.underscore.humanize, t.entidad_type]}
    @entidades = Entidad.select("DISTINCT entidad_type").collect do |ent|
      Entidad.where(entidad_type: ent.entidad_type).includes(:entidad).collect do |e|
        [e.entidad.nombre, e.id, {class: ent.entidad_type}]
      end
    end.flatten!(1).uniq

    # Bancos
    @bancos = Banco.all.collect {|b| [b.nombre, b.id]}
    @sucursales_bancarias = Banco.all.collect do |b|
      b.sucursales_bancarias.collect do |s|
        [
          s.nombre.present? ? s.numero + "- " + s.nombre : s.numero , 
          s.id, 
          {class: b.id}
        ]
      end
    end.flatten(1).uniq

    @tipos_de_cuentas = TipoDeCuentaBancaria.all.collect {|t| [t.nombre, t.id]}
  end

  # POST /cuentas_bancarias
  def create
    @cuenta_bancaria = CuentaBancaria.new(params[:cuenta_bancaria])

    
    if @cuenta_bancaria.save
      redirect_to @cuenta_bancaria, flash: { tipo: :ok, titulo: 'La cuenta bancaria se creó correctamente.' }
    else
      # Datos para selects 
      # Entidades
      @tipos_de_entidades = Entidad.select("DISTINCT entidad_type").collect {|t| [t.entidad_type.underscore.humanize, t.entidad_type]}
      @entidades = Entidad.select("DISTINCT entidad_type").collect do |ent|
        Entidad.where(entidad_type: ent.entidad_type).includes(:entidad).collect do |e|
          [e.entidad.nombre, e.id, {class: ent.entidad_type}]
        end
      end.flatten!(1).uniq

      # Bancos
      @bancos = Banco.all.collect {|b| [b.nombre, b.id]}
      @sucursales_bancarias = Banco.all.collect do |b|
        b.sucursales_bancarias.collect do |s|
          [
            s.nombre.present? ? s.numero + "- " + s.nombre : s.numero , 
            s.id, 
            {class: b.id}
          ]
        end
      end.flatten(1).uniq

      @tipos_de_cuentas = TipoDeCuentaBancaria.all.collect {|t| [t.nombre, t.id]}
      render action: "new" 
    end
    
  end

  # PUT /cuentas_bancarias/1
  # PUT /cuentas_bancarias/1.json
  def update
    @cuenta_bancaria = CuentaBancaria.find(params[:id])

    respond_to do |format|
      if @cuenta_bancaria.update_attributes(params[:cuenta_bancaria])
        format.html { redirect_to @cuenta_bancaria, notice: 'Cuenta bancaria was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cuenta_bancaria.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cuentas_bancarias/1
  # DELETE /cuentas_bancarias/1.json
  def destroy
    @cuenta_bancaria = CuentaBancaria.find(params[:id])
    @cuenta_bancaria.destroy

    respond_to do |format|
      format.html { redirect_to cuentas_bancarias_url }
      format.json { head :no_content }
    end
  end

  private 

  def verificar_permisos
    if not current_user.in_group? [:coordinacion, :facturacion, :capacitacion, :comunicacion, :planificacion, :convenios, :auditoria_medica, :auditoria_control]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
  end
end