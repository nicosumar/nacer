class SexosController < ApplicationController
  
  before_filter :buscar_grupo_pdss, only: [:index]

  def index
    @sexos = @grupo_pdss.present? ? @grupo_pdss.sexos : Sexo.all
    respond_to do |format|
      format.json { render json: @sexos.uniq }
    end
  end

  private

    def buscar_grupo_pdss
      @grupo_pdss = GrupoPdss.find(params[:grupo_pdss_id]) if params[:grupo_pdss_id].present?
    end

end