# -*- encoding : utf-8 -*-
class SucursalesBancariasController < ApplicationController

  before_filter :authenticate_user!
  before_filter :verificar_permisos

  # GET /sucursales_bancarias
  def index
    @sucursales_bancarias = SucursalBancaria.includes(:banco, :pais, :provincia, :departamento, :distrito).all
  end

  # GET /sucursales_bancarias/1
  def show
    @sucursal_bancaria = SucursalBancaria.includes(:banco, :pais, :provincia, :departamento, :distrito).find(params[:id])
  end

  # GET /sucursales_bancarias/new
  def new
    @sucursal_bancaria = SucursalBancaria.new

    # Variables para los select
    @bancos = Banco.all.collect {|p| [p.nombre, p.id]}

    @paises = Pais.includes(:provincias).all.collect {|p| [p.nombre, p.id]}
    @provincias = Pais.includes(:provincias).all.collect do |p|
      p.provincias.collect do |prov|
        [prov.nombre, prov.id, {class: p.id}]
      end
    end.flatten!(1).uniq
    @departamentos = Provincia.includes(:departamentos).all.collect do |p|
      p.departamentos.collect do |d|
        [d.nombre, d.id, {class: p.id}]
      end
    end.flatten!(1).uniq
    @distritos = Departamento.includes(:distritos).all.collect do |de|
      de.distritos.collect do |d|
        [d.nombre, d.id, {class: de.id}]
      end
    end.flatten!(1).uniq
  end

  # GET /sucursales_bancarias/1/edit
  def edit
    @sucursal_bancaria = SucursalBancaria.includes(:banco, :pais, :provincia, :departamento, :distrito).find(params[:id])

    # Variables para los select
    @bancos = Banco.all.collect {|p| [p.nombre, p.id]}

    @paises = Pais.includes(:provincias).all.collect {|p| [p.nombre, p.id]}
    @provincias = Pais.includes(:provincias).all.collect do |p|
      p.provincias.collect do |prov|
        [prov.nombre, prov.id, {class: p.id}]
      end
    end.flatten!(1).uniq
    @departamentos = Provincia.includes(:departamentos).all.collect do |p|
      p.departamentos.collect do |d|
        [d.nombre, d.id, {class: p.id}]
      end
    end.flatten!(1).uniq
    @distritos = Departamento.includes(:distritos).all.collect do |de|
      de.distritos.collect do |d|
        [d.nombre, d.id, {class: de.id}]
      end
    end.flatten!(1).uniq
  end

  # POST /sucursales_bancarias
  def create
    @sucursal_bancaria = SucursalBancaria.new(params[:sucursal_bancaria])

    if @sucursal_bancaria.save
      redirect_to @sucursal_bancaria, :flash => { :tipo => :ok, :titulo => 'La sucursal se creó correctamente.' }
    else
      # Variables para los select
      @bancos = Banco.all.collect {|p| [p.nombre, p.id]}

      @paises = Pais.includes(:provincias).all.collect {|p| [p.nombre, p.id]}
      @provincias = Pais.includes(:provincias).all.collect do |p|
        p.provincias.collect do |prov|
          [prov.nombre, prov.id, {class: p.id}]
        end
      end.flatten!(1).uniq
      @departamentos = Provincia.includes(:departamentos).all.collect do |p|
        p.departamentos.collect do |d|
          [d.nombre, d.id, {class: p.id}]
        end
      end.flatten!(1).uniq
      @distritos = Departamento.includes(:distritos).all.collect do |de|
        de.distritos.collect do |d|
          [d.nombre, d.id, {class: de.id}]
        end
      end.flatten!(1).uniq
      render action: "new" 
    end
  end # end create

  # PUT /sucursales_bancarias/1
  def update
    @sucursal_bancaria = SucursalBancaria.includes(:banco, :pais, :provincia, :departamento, :distrito).find(params[:id])

    if @sucursal_bancaria.update_attributes(params[:sucursal_bancaria])
      redirect_to @sucursal_bancaria, :flash => {:tipo => :ok, :titulo => 'Las modificaciones a la sucursal bancaria se guardaron correctamente.' }
    else
      # Variables para los select
      @bancos = Banco.all.collect {|p| [p.nombre, p.id]}

      @paises = Pais.includes(:provincias).all.collect {|p| [p.nombre, p.id]}
      @provincias = Pais.includes(:provincias).all.collect do |p|
        p.provincias.collect do |prov|
          [prov.nombre, prov.id, {class: p.id}]
        end
      end.flatten!(1).uniq
      @departamentos = Provincia.includes(:departamentos).all.collect do |p|
        p.departamentos.collect do |d|
          [d.nombre, d.id, {class: p.id}]
        end
      end.flatten!(1).uniq
      @distritos = Departamento.includes(:distritos).all.collect do |de|
        de.distritos.collect do |d|
          [d.nombre, d.id, {class: de.id}]
        end
      end.flatten!(1).uniq
      
      render action: "edit" 
    end
  end

  # DELETE /sucursales_bancarias/1
  def destroy
    @sucursal_bancaria = SucursalBancaria.find(params[:id])
    @sucursal_bancaria.destroy

    redirect_to sucursales_bancarias_url
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
  end #end verificar permisos

end # end controller