# -*- encoding : utf-8 -*-
class OrganismosGubernamentalesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :verificar_permisos

  # GET /organismos_gubernamentales
  def index
    @organismos_gubernamentales = OrganismoGubernamental.all
  end

  # GET /organismos_gubernamentales/1
  def show
    @organismo_gubernamental = OrganismoGubernamental.find(params[:id])
  end

  # GET /organismos_gubernamentales/new
  def new
    @organismo_gubernamental = OrganismoGubernamental.new

    @provincias = Provincia.all.collect {|p| [p.nombre, p.id]}
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

  # GET /organismos_gubernamentales/1/edit
  def edit
    @organismo_gubernamental = OrganismoGubernamental.find(params[:id])

    @provincias = Provincia.all.collect {|p| [p.nombre, p.id]}
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

  # POST /organismos_gubernamentales
  def create
    @organismo_gubernamental = OrganismoGubernamental.new(params[:organismo_gubernamental])

    if @organismo_gubernamental.save
      redirect_to @organismo_gubernamental, :flash => { :tipo => :ok, :titulo => 'El Organismo se creó correctamente.' }
    else
      @provincias = Provincia.all.collect {|p| [p.nombre, p.id]}

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
  end

  # PUT /organismos_gubernamentales/1
  def update
    @organismo_gubernamental = OrganismoGubernamental.find(params[:id])
    
    if @organismo_gubernamental.update_attributes(params[:organismo_gubernamental])
      redirect_to @organismo_gubernamental, :flash => {:tipo => :ok, :titulo => 'Las modificaciones al Organismo Gubernamental se guardaron correctamente.' }
    else
      @provincias = Provincia.all.collect {|p| [p.nombre, p.id]}

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

  # DELETE /organismos_gubernamentales/1
  def destroy
    @organismo_gubernamental = OrganismoGubernamental.find(params[:id])
    @organismo_gubernamental.destroy
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
