# -*- encoding : utf-8 -*-
class FormulasController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verificar_permisos
 
  # GET /formulas
  def index
    @formulas = Formula.all
  end

  # GET /formulas/1
  def show
    @formula = Formula.find(params[:id])
  end

  # GET /formulas/new
  def new
    @formula = Formula.new
  end

  # GET /formulas/1/edit
  def edit
    @formula = Formula.find(params[:id])
  end

  # POST /formulas
  def create
    @formula = Formula.new(params[:formula])
   
    if @formula.save
      redirect_to @formula, :flash => { :tipo => :ok, :titulo => "Se creó la formula '#{@formula.descripcion}'. #{@formula.crear_formula} " } 
    else
      render action: "new" 
    end
  end

  # PUT /formulas/1
  def update
    @formula = Formula.find(params[:id])

    if @formula.update_attributes(params[:formula])
      redirect_to @formula, :flash => { :tipo => :ok, :titulo => "Se actualizó la formula '#{@formula.descripcion}'. #{@formula.crear_formula}" } 
    else
      render action: "edit" 
    end
  end

  # DELETE /formulas/1
  def destroy
    @formula = Formula.find(params[:id])
    @formula.destroy

    redirect_to formulas_url 
  end

  private 

  def verificar_permisos
    if not current_user.in_group?(:coordinacion)
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
  end

end
