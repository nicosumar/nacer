class AnexosAdministrativosPrestacionesController < ApplicationController

  def update_status
    @anexo_administrativo_prestacion = AnexoAdministrativoPrestacion.find(params[:id])
    if params[:anexo_administrativo_prestacion][:estado_de_la_prestacion_id].blank?
      nuevo_estado = nil
    else
      nuevo_estado = EstadoDeLaPrestacion.find(params[:anexo_administrativo_prestacion][:estado_de_la_prestacion_id])
    end
    @anexo_administrativo_prestacion.estado_de_la_prestacion = nuevo_estado
    @anexo_administrativo_prestacion.save
  end

  def update_motivo_rechazo
    @anexo_administrativo_prestacion = AnexoAdministrativoPrestacion.find(params[:id])
    nuevo_motivo = MotivoDeRechazo.find(params[:anexo_administrativo_prestacion][:motivo_de_rechazo_id])
    @anexo_administrativo_prestacion.motivo_de_rechazo = nuevo_motivo
    @anexo_administrativo_prestacion.save
  end

end
