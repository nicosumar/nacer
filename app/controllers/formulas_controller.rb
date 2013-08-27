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

    #borro los espacios extras y saltos de linea
    @formula.formula = @formula.formula.split.join(" ")

    if @formula.save
      redirect_to @formula, notice: 'Formula was successfully created.' 
    else
      render action: "new" 
    end

  end

  # PUT /formulas/1
  def update
    @formula = Formula.find(params[:id])

    if @formula.update_attributes(params[:formula])
      redirect_to @formula, notice: 'Formula was successfully updated.' 
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
