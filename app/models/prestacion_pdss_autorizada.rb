# -*- encoding : utf-8 -*-
class PrestacionPdssAutorizada < ActiveRecord::Base
  # Este es un modelo falso, basado en una vista y no una tabla real, por lo que no tiene definido un PRIMARY KEY
  self.primary_keys = :autorizante_al_alta_type, :autorizante_al_alta_id, :prestacion_pdss_id

  attr_protected nil
  attr_readonly :prestacion_pdss_id

  # Asociaciones
  belongs_to :efector
  belongs_to :prestacion_pdss
  belongs_to :autorizante_al_alta, :polymorphic => true
  belongs_to :autorizante_de_la_baja, :polymorphic => true
  has_many :prestaciones, :through => :prestacion_pdss

  # Validaciones
  validates_presence_of :efector_id, :prestacion_pdss_id, :fecha_de_inicio, :autorizante_al_alta_type, :autorizante_al_alta_id

  # Devuelve las prestaciones autorizadas para el ID del efector que se pasa como parámetro
  # y que aún no han sido dadas de baja.
#  def self.autorizadas(efector_id)
#    where(:efector_id => efector_id)
#  end

  # Devuelve las prestaciones que estaban autorizadas para el ID del efector
  # antes de la fecha indicada en los parámetros.
#  def self.autorizadas_antes_del_dia(efector_id, fecha)
#    where("
#      efector_id = '#{efector_id}'
#      AND fecha_de_inicio < '#{fecha.strftime("%Y-%m-%d")}'
#      AND (fecha_de_finalizacion IS NULL OR fecha_de_finalizacion >= '#{fecha.strftime("%Y-%m-%d")}')
#    ")
#  end

  # prestaciones_autorizadas_pdss
  # Devuelve todas las prestaciones del PDSS, serializadas en un Hash con su grupo, subgrupo, apartado, etc. e
  # indicando cuáles prestaciones están autorizadas según el objeto pasado como parámetro.
  def serializar_pdss(objeto, fecha = Date.today)
    raise ArgumentError unless (objeto.is_a? Efector || objeto.is_a? ConvenioDeGestionSumar)

    prestaciones_pdss_autorizadas_ids = objeto.prestaciones_pdss_autorizadas_ids(fecha)

    grupos = []
    GrupoPdss.find(:all, :order => :orden).each do |g|
      if g.subgrupos_pdss.size > 0
        subgrupos_del_grupo = []
        SubgrupoPdss.where(:grupo_pdss_id => g.id).order(:orden).each do |s|
          if s.apartados_pdss.size > 0
            apartados_del_subgrupo = []
            ApartadoPdss.where(:subgrupo_pdss_id => s.id).order(:orden).each do |a|
              prestaciones_del_apartado = []
              PrestacionPdss.where(:grupo_pdss_id => g.id, :subgrupo_pdss_id => s.id, :apartado_pdss_id => a.id).order(:orden).each do |p|
                if prestaciones_pdss_autorizadas_ids.member?(p.id)
                  prestaciones_del_apartado << p.attributes.merge!(:autorizada => true)
                  if objeto.is_a? Efector
                    # Añadir información del instrumento legal que autorizó la prestación
                    prestaciones_del_apartado <<
                      PrestacionAutorizada.joins({:prestacion => :prestaciones_pdss}).where("
                      --??? MIERDA
                      ").first.autorizante_al_alta
                    })
                else
                  prestaciones_del_apartado << p.attributes.merge!(:autorizada => false)
                end
              end
              apartados_del_subgrupo << a.attributes.merge!(:prestaciones => prestaciones_del_apartado)
            end
            subgrupos_del_grupo << s.attributes.merge!(:apartados => apartados_del_subgrupo)
          else
            prestaciones_del_subgrupo = []
            PrestacionPdss.where(:grupo_pdss_id => g.id, :subgrupo_pdss_id => s.id).order(:orden).each do |p|
              if prestaciones_pdss_autorizadas.member?(p.id)
                prestaciones_del_subgrupo << p.attributes.merge!({
                  :autorizada => true,
                  :autorizador => PrestacionAutorizada.joins({:prestacion => :prestaciones_pdss}).where("
                    \"prestaciones_autorizadas\".\"efector_id\" = #{self.id}
                    AND \"prestaciones_autorizadas\".\"fecha_de_inicio\" <= '#{fecha.strftime("%Y-%m-%d")}'
                    AND (
                      \"prestaciones_autorizadas\".\"fecha_de_finalizacion\" IS NULL
                      OR \"prestaciones_autorizadas\".\"fecha_de_finalizacion\" > '#{fecha.strftime("%Y-%m-%d")}'
                    )
                    AND \"prestaciones_pdss\".\"id\" = #{p.id}
                  ").first.autorizante_al_alta
                })
              else
                prestaciones_del_subgrupo << p.attributes.merge!(:autorizada => false)
              end
            end
            subgrupos_del_grupo << s.attributes.merge!(:prestaciones => prestaciones_del_subgrupo)
          end
        end
        grupos << g.attributes.merge!(:subgrupos => subgrupos_del_grupo)
      else
        prestaciones_del_grupo = []
        PrestacionPdss.where(:grupo_pdss_id => g.id).order(:orden).each do |p|
          if prestaciones_pdss_autorizadas.member?(p.id)
            prestaciones_del_grupo << p.attributes.merge!({
              :autorizada => true,
              :autorizador => PrestacionAutorizada.joins({:prestacion => :prestaciones_pdss}).where("
                \"prestaciones_autorizadas\".\"efector_id\" = #{self.id}
                AND \"prestaciones_autorizadas\".\"fecha_de_inicio\" <= '#{fecha.strftime("%Y-%m-%d")}'
                AND (
                  \"prestaciones_autorizadas\".\"fecha_de_finalizacion\" IS NULL
                  OR \"prestaciones_autorizadas\".\"fecha_de_finalizacion\" > '#{fecha.strftime("%Y-%m-%d")}'
                )
                AND \"prestaciones_pdss\".\"id\" = #{p.id}
              ").first.autorizante_al_alta
            })
          else
            prestaciones_del_grupo << p.attributes.merge!(:autorizada => false)
          end
        end
        grupos << g.attributes.merge!(:prestaciones => prestaciones_del_grupo)
      end
    end
    return grupos
  end

end
