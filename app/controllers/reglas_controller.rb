# -*- encoding : utf-8 -*-
class ReglasController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verificar_lectura

  # GET /reglas
  def index
    @reglas = Regla.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /reglas/1
  def show
    @regla = Regla.find(params[:id])
  end

  # GET /reglas/new
  def new
    @regla = Regla.new
    @efectores = Efector.all.collect {|e| [e.nombre, e.id]}
    @nomencladores =  Nomenclador.all.collect {|e| [e.nombre, e.id]}
    @prestaciones = Prestacion.find(:all, include: :nomencladores).collect do |p|
      p.nomencladores.collect do |n|
        ["#{p.id}| #{p.codigo} |#{p.nombre_corto}", p.id, {:class => n.id} ]
      end
    end.flatten!(1).uniq
   
    @metodos_de_validacion = MetodoDeValidacion.find(:all, include: :prestaciones).collect do |m|
      m.prestaciones.collect do |p|
        ["#{m.id}| #{m.nombre}", m.id, {:class => p.id} ]
      end
    end.flatten!(1).uniq
  end

  # GET /reglas/1/edit
  def edit
    @regla = Regla.find(params[:id])
    @efectores = Efector.all.collect {|e| [e.nombre, e.id]}
    @nomencladores =  Nomenclador.all.collect {|e| [e.nombre, e.id]}
    @prestaciones = Prestacion.find(:all, include: :nomencladores).collect do |p|
      p.nomencladores.collect do |n|
        ["#{p.id}| #{p.codigo} |#{p.nombre_corto}", p.id, {:class => n.id} ]
      end
    end.flatten!(1).uniq
   
    @metodos_de_validacion = MetodoDeValidacion.find(:all, include: :prestaciones).collect do |m|
      m.prestaciones.collect do |p|
        ["#{m.id}| #{m.nombre}", m.id, {:class => p.id} ]
      end
    end.flatten!(1).uniq
  end

  # POST /reglas
  def create
    @regla = Regla.new(params[:regla])
    if @regla.save
      redirect_to @regla, :flash => { :tipo => :ok, :titulo => "Se creó la regla #{@regla.nombre} correctamente" } 
    else
      @efectores = Efector.all.collect {|e| [e.nombre, e.id]}
      @nomencladores =  Nomenclador.all.collect {|e| [e.nombre, e.id]}
      @prestaciones = Prestacion.find(:all, include: :nomencladores).collect do |p|
        p.nomencladores.collect do |n|
          ["#{p.id}| #{p.codigo} |#{p.nombre_corto}", p.id, {:class => n.id} ]
        end
      end.flatten!(1).uniq
     
      @metodos_de_validacion = MetodoDeValidacion.find(:all, include: :prestaciones).collect do |m|
        m.prestaciones.collect do |p|
          ["#{m.id}| #{m.nombre}", m.id, {:class => p.id} ]
        end
      end.flatten!(1).uniq
      render action: "new" 
    end
  end

  # PUT /reglas/1
  def update
    @regla = Regla.find(params[:id])

    if @regla.update_attributes(params[:regla])
      redirect_to @regla, :flash => { :tipo => :ok, :titulo => "Se actualizo la regla #{@regla.nombre} correctamente" } 
    else
      @efectores = Efector.all.collect {|e| [e.nombre, e.id]}
      @nomencladores =  Nomenclador.all.collect {|e| [e.nombre, e.id]}
      @prestaciones = Prestacion.find(:all, include: :nomencladores).collect do |p|
        p.nomencladores.collect do |n|
          ["#{p.id}| #{p.codigo} |#{p.nombre_corto}", p.id, {:class => n.id} ]
        end
      end.flatten!(1).uniq
     
      @metodos_de_validacion = MetodoDeValidacion.find(:all, include: :prestaciones).collect do |m|
        m.prestaciones.collect do |p|
          ["#{m.id}| #{m.nombre}", m.id, {:class => p.id} ]
        end
      end.flatten!(1).uniq
      render action: "edit" 
    end
  end

  # DELETE /reglas/1
  def destroy
    @regla = Regla.find(params[:id])
    @regla.destroy

    redirect_to reglas_url 
  end

  private

  def verificar_lectura
    if cannot? :read, Regla
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end

end
