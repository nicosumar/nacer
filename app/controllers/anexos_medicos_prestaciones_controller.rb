class AnexosMedicosPrestacionesController < ApplicationController

   def update_status
    @anexo_medico_prestacion = AnexoMedicoPrestacion.find(params[:id])
    if params[:anexo_medico_prestacion][:estado_de_la_prestacion_id].blank?
      nuevo_estado = nil
    else
      nuevo_estado = EstadoDeLaPrestacion.find(params[:anexo_medico_prestacion][:estado_de_la_prestacion_id])
    end
    @anexo_medico_prestacion.estado_de_la_prestacion = nuevo_estado
    @anexo_medico_prestacion.save
  end

  def update_motivo_rechazo
    @anexo_medico_prestacion = AnexoMedicoPrestacion.find(params[:id])
    if params[:anexo_medico_prestacion].blank? || params[:anexo_medico_prestacion][:motivo_de_rechazo_id].blank?
      nuevo_motivo = nil
    else
      nuevo_motivo = MotivoDeRechazo.find(params[:anexo_medico_prestacion][:motivo_de_rechazo_id])
    end

    @anexo_medico_prestacion.motivo_de_rechazo = nuevo_motivo
    @anexo_medico_prestacion.save
  end
end
