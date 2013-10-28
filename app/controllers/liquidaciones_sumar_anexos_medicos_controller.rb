# -*- encoding : utf-8 -*-
class LiquidacionesSumarAnexosMedicosController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :verificar_lectura

  # GET /liquidaciones_sumar_anexos_medicos/1
  def show
    @liquidacion_sumar_anexo_medico = LiquidacionSumarAnexoMedico.find(params[:id])
    if @liquidacion_sumar_anexo_medico.estado_del_proceso.codigo !="C"
      flash[:tipo] = :ok
      flash[:titulo] = "El anexo se encuentra #{@liquidacion_sumar_anexo_medico.estado_del_proceso.nombre}"
    end
    condiciones = {}
    condiciones.merge!({liquidacion_sumar_anexo_medico_id: @liquidacion_sumar_anexo_medico.id}) 
    
    # Crea la instancia del grid (o lleva los resultados del model al grid)
    @detalle_anexo = initialize_grid(
      AnexoMedicoPrestacion,
      #include: [:prestacion_liquidada, :estado_de_la_prestacion],
      include: [{prestacion_liquidada: :afiliado}, {prestacion_liquidada: :prestacion_incluida}, :estado_de_la_prestacion ],
      joins:  "join prestaciones_liquidadas on prestaciones_liquidadas.id = anexos_medicos_prestaciones.prestacion_liquidada_id\n"+
              "join prestaciones_incluidas on prestaciones_incluidas.id = prestaciones_liquidadas.prestacion_incluida_id\n"+
              "join afiliados on afiliados.clave_de_beneficiario = prestaciones_liquidadas.clave_de_beneficiario\n",
      order: "afiliados.numero_de_documento",
      conditions: condiciones
      )

    # TODO: Ver para parametrizar los esados de las prestaciones a incluir 
    @estados_de_las_prestaciones = EstadoDeLaPrestacion.where(id: [5,6,7,nil]).collect {|c| [c.nombre, c.id]}
    @motivos_de_rechazo = MotivoDeRechazo.where(categoria: "Medica").collect do |m|
      EstadoDeLaPrestacion.where(id: [5,6,7,nil]).collect do |n|
        [m.nombre, m.id, {:class => n.id} ] if n.id >= 6
      end
    end.flatten!(1).uniq
    @motivos_de_rechazo.delete nil
  end

  def finalizar_anexo
    @liquidacion_sumar_anexo_medico = LiquidacionSumarAnexoMedico.find(params[:id])

    @liquidacion_sumar_anexo_medico.finalizar_anexo

    redirect_to @liquidacion_sumar_anexo_medico,:flash => { :tipo => :ok, :titulo => "El anexo se finalizó correctamente" } 
  end
  private 

  def verificar_lectura
    if cannot? :read, LiquidacionSumarAnexoMedico
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end
end
