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
  # Devuelve todas las prestaciones del PDSS, serializadas en un Hash con su sección y grupo, subgrupo, e
  # indicando cuáles prestaciones están autorizadas según el objeto pasado como parámetro.
  def self.efector_y_fecha(efector_id, fecha = Date.today)
    qres = ActiveRecord::Base.connection.exec_query( <<-SQL
        SELECT DISTINCT ON (sp.orden, gp.orden, pp.orden)
            sp.id "seccion_pdss_id",
            gp.id "grupo_pdss_id",
            pp.id "prestacion_pdss_id",
            lc.nombre "linea_de_cuidado",
            mp.nombre "modulo",
            tdp.nombre "tipo_de_prestacion",
            codigo_de_prestacion_con_diagnosticos(pp.id) "codigo_de_prestacion",
            pp.nombre "nombre_de_prestacion",
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
            to_char(ppa.fecha_de_inicio, 'DD/MM/YYYY') "fecha_de_inicio",
            CASE
              WHEN EXISTS (
                  SELECT * FROM areas_de_prestacion_prestaciones_pdss appp
                    WHERE appp.prestacion_pdss_id = pp.id AND appp.area_de_prestacion_id = '2'
                ) THEN 't'::boolean
              ELSE 'f'::boolean
            END "rural"
          FROM
            prestaciones_pdss pp
            LEFT JOIN prestaciones_prestaciones_pdss ppp ON pp.id = ppp.prestacion_pdss_id
            LEFT JOIN prestaciones p ON p.id = ppp.prestacion_id
            LEFT JOIN grupos_pdss gp ON gp.id = pp.grupo_pdss_id
            LEFT JOIN secciones_pdss sp ON sp.id = gp.seccion_pdss_id
            LEFT JOIN lineas_de_cuidado lc ON lc.id = pp.linea_de_cuidado_id
            LEFT JOIN modulos mp ON mp.id = pp.modulo_id
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
          ORDER BY sp.orden, gp.orden, pp.orden;
      SQL
    )

    secciones = []
    SeccionPdss.where(true).order(:orden).select([:id, :codigo, :nombre]).each do |s|
      if s.grupos_pdss.size > 0
        grupos_de_la_seccion = []
        GrupoPdss.where(:seccion_pdss_id => s.id).order(:orden).select([:id, :codigo, :nombre]).each do |g|
          grupos_de_la_seccion << g.attributes.merge!(:prestaciones => self.obtener_prestaciones(qres.columns, qres.rows.dup.keep_if{|r| r[0] == s.id.to_s && r[1] == g.id.to_s}))
        end
        secciones << s.attributes.merge!(:grupos => grupos_de_la_seccion)
      else
        secciones << s.attributes.merge!(:prestaciones => self.obtener_prestaciones(qres.columns, qres.rows.dup.keep_if{|r| r[0] == s.id.to_s}))
      end
    end
    return secciones
  end
#-----------------------------------------------------------------------------------------
def self.pres_autorizadas(efector_id, fecha = Date.today, prestacion_id)
  Date.today.strftime("%d/%m/%Y")
  fecha = Date.today
    qres = ActiveRecord::Base.connection.exec_query( <<-SQL
                                                             SELECt
                                                                ppa.*
                                                                FROM
                                                                prestaciones_pdss_autorizadas as ppa,
                                                                prestaciones_prestaciones_pdss as pppdss
                                                                WHERE
                                                                ppa.efector_id = #{efector_id}
                                                                AND ('#{fecha.iso8601}' between fecha_de_inicio and fecha_de_finalizacion OR (fecha_de_inicio <= '#{fecha.iso8601}' and fecha_de_finalizacion is null))
                                                                AND  pppdss.prestacion_pdss_id = ppa.prestacion_pdss_id AND    pppdss.prestacion_pdss_id = '#{prestacion_id}'

      SQL
    )
    return qres
  end
#-----------------------------------------------------------------------------------------
  def self.obtener_prestaciones(nombres, valores)
    prestaciones = []
    valores.each do |r|
      atributos = {}
      r.each_with_index do |v, i|
        atributos.merge!(nombres[i] => v) if i > 1
      end
      prestaciones << atributos
    end
    return prestaciones
  end

end
