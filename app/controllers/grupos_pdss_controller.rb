class GruposPdssController < ApplicationController
  
  before_filter :buscar_seccion_pdss, only: [:index]

  def index
    @grupos_pdss = @seccion_pdss.present? ? @seccion_pdss.grupos_pdss : GrupoPdss.all
    respond_to do |format|
      format.json { render json: @grupos_pdss }
    end
  end

  private

    def buscar_seccion_pdss
      @seccion_pdss = SeccionPdss.find(params[:seccion_pdss_id]) if params[:seccion_pdss_id].present?
    end

end