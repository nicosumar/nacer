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

  # PRESENTACION - devuelve un objeto para presentación en la vista. Evaluar el uso de funciones específicas para la capa de presentación
  # self.efector_y_fecha
  # Devuelve todas las prestaciones del PDSS, serializadas en un Hash con su grupo, subgrupo, apartado, etc. e
  # indicando cuáles prestaciones están autorizadas según el objeto pasado como parámetro.
  def self.efector_y_fecha(efector_id, fecha = Date.today)
    qres = ActiveRecord::Base.connection.exec_query( <<-SQL
        SELECT
            gp.id "grupo_pdss_id",
            sp.id "subgrupo_pdss_id",
            ap.id "apartado_pdss_id",
            pp.id "prestacion_pdss_id",
            n.nombre "nosologia",
            tdp.nombre "tipo_de_prestacion",
            pp.codigo "codigo_de_prestacion",
            pp.nombre "nombre_de_prestacion",
            pp.rural "rural",
            CASE WHEN ppa.autorizante_al_alta_type IS NOT NULL THEN 't'::boolean ELSE 'f'::boolean END "autorizada",
            CASE
              WHEN ppa.autorizante_al_alta_type = 'ConvenioDeGestionSumar' THEN 'Convenio de gestión'::varchar(255)
              WHEN ppa.autorizante_al_alta_type = 'AddendaSumar' THEN 'Adenda'::varchar(255)
              ELSE NULL::varchar(255)
            END "tipo_de_autorizador",
            CASE
              WHEN ppa.autorizante_al_alta_type = 'ConvenioDeGestionSumar' THEN cgs.numero
              WHEN ppa.autorizante_al_alta_type = 'AddendaSumar' THEN ads.numero
              ELSE NULL::varchar(255)
            END "numero_de_autorizador",
            to_char(ppa.fecha_de_inicio, 'DD/MM/YYYY') "fecha_de_inicio"
          FROM
            prestaciones_pdss pp
            LEFT JOIN grupos_pdss gp ON gp.id = pp.grupo_pdss_id
            LEFT JOIN subgrupos_pdss sp ON sp.id = pp.subgrupo_pdss_id
            LEFT JOIN apartados_pdss ap ON ap.id = pp.apartado_pdss_id
            LEFT JOIN nosologias n ON n.id = pp.nosologia_id
            LEFT JOIN tipos_de_prestaciones tdp ON tdp.id = pp.tipo_de_prestacion_id
            LEFT JOIN prestaciones_pdss_autorizadas ppa ON (
              ppa.efector_id = #{efector_id}
              AND ppa.fecha_de_inicio <= '#{fecha.iso8601}'
              AND (ppa.fecha_de_finalizacion IS NULL OR ppa.fecha_de_finalizacion > '#{fecha.iso8601}')
              AND ppa.prestacion_pdss_id = pp.id
            )
            LEFT JOIN convenios_de_gestion_sumar cgs ON (
              ppa.autorizante_al_alta_type = 'ConvenioDeGestionSumar'
              AND ppa.autorizante_al_alta_id = cgs.id
            )
            LEFT JOIN addendas_sumar ads ON (
              ppa.autorizante_al_alta_type = 'AddendaSumar' AND
              ppa.autorizante_al_alta_id = ads.id
            )
          ORDER BY gp.orden, sp.orden, ap.orden, pp.orden;
      SQL
    )

    grupos = []
    GrupoPdss.where(true).order(:orden).select([:id, :codigo, :nombre]).each do |g|
      if g.subgrupos_pdss.size > 0
        subgrupos_del_grupo = []
        SubgrupoPdss.where(:grupo_pdss_id => g.id).order(:orden).select([:id, :codigo, :nombre]).each do |s|
          if s.apartados_pdss.size > 0
            apartados_del_subgrupo = []
            ApartadoPdss.where(:subgrupo_pdss_id => s.id).order(:orden).select([:id, :codigo, :nombre]).each do |a|
              apartados_del_subgrupo << a.attributes.merge!(:prestaciones => self.obtener_prestaciones(qres.columns, qres.rows.dup.keep_if{|r| r[0] == g.id.to_s && r[1] == s.id.to_s && r[2] == a.id.to_s}))
            end
            subgrupos_del_grupo << s.attributes.merge!(:apartados => apartados_del_subgrupo)
          else
            subgrupos_del_grupo << s.attributes.merge!(:prestaciones => self.obtener_prestaciones(qres.columns, qres.rows.dup.keep_if{|r| r[0] == g.id.to_s && r[1] == s.id.to_s}))
          end
        end
        grupos << g.attributes.merge!(:subgrupos => subgrupos_del_grupo)
      else
        grupos << g.attributes.merge!(:prestaciones => self.obtener_prestaciones(qres.columns, qres.rows.dup.keep_if{|r| r[0] == g.id.to_s}))
      end
    end
    return grupos
  end

  def self.obtener_prestaciones(nombres, valores)
    prestaciones = []
    valores.each do |r|
      atributos = {}
      r.each_with_index do |v, i|
        atributos.merge!(nombres[i] => v) if i > 2
      end
      prestaciones << atributos
    end
    return prestaciones
  end

end
