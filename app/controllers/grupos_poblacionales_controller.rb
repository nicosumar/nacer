class GruposPoblacionalesController < ApplicationController
  
  before_filter :buscar_grupo_pdss, only: [:index]

  def index
    @grupos_poblacionales = @grupo_pdss.present? ? @grupo_pdss.grupos_poblacionales : GrupoPoblacional.all
    respond_to do |format|
      format.json { render json: @grupos_poblacionales.uniq }
    end
  end

  private

    def buscar_grupo_pdss
      @grupo_pdss = GrupoPdss.find(params[:grupo_pdss_id]) if params[:grupo_pdss_id].present?
    end

end