# -*- encoding : utf-8 -*-
class Informe < ActiveRecord::Base
  has_many :informes_filtros
  has_many :informes_uads
  has_many :esquemas, :through => :informes_uads, :class_name => 'UnidadDeAltaDeDatos'
  
  accepts_nested_attributes_for :informes_filtros, :reject_if => :all_blank, :allow_destroy => true
  
  attr_accessible :titulo
  attr_accessible :sql
  attr_accessible :metodo
  attr_accessible :nombre_partial
  attr_accessible :informes_filtros_attributes

  attr_accessor :nombres_de_columna

  #"Sexy" validations
  validates :titulo, presence: true
  validates :nombre_partial, presence: true

  validates_associated :informes_filtros

  # Los informes que se ejecutan con codigo sql siempre deben devolver 
  # un array de objetos de tipo CustomQuery, sea cual fuese el origen de los datos
  # del informe.
  
  def ejecutar(parametros=[])

    #traigo los parametros del reporte y los ordeno para el query
    valores = []
    logger
    parametros.sort.each { |p, v| valores << v} if parametros.present?
    
    if self.sql.present?

      #Al ser todos o incluidos o excluidos, busco los codigos, y despues verifico si se incluye o excluye
      if self.informes_uads.first.incluido == 1
        cq = CustomQuery.buscar (
          {
            esquemas: self.esquemas,
            sql: self.sql,
            values: valores
          })
      else
        cq = CustomQuery.buscar (
          {
            except: self.esquemas,
            sql: self.sql,
            values: valores
          })
      end
      self.nombres_de_columna = cq.first.nombres_de_columnas

      return cq
    else # ruby code
      cq = CustomQuery.buscar({
          ruby: self.metodo,
          values: valores
        })

      self.nombres_de_columna = cq.first.nombres_de_columnas
      return cq
    end
    return nil
  end

  def ejecutar_csv(parametros=[])
    #traigo los parametros del reporte y los ordeno para el query
    valores = []
    logger
    parametros.sort.each { |p, v| valores << v} if parametros.present?
    
    if self.sql.present?

      #Al ser todos o incluidos o excluidos, busco los codigos, y despues verifico si se incluye o excluye
      if self.informes_uads.first.incluido == 1
        cq = CustomQuery.buscar (
          {
            esquemas: self.esquemas,
            sql: self.sql,
            values: valores
          })
      else
        cq = CustomQuery.buscar (
          {
            except: self.esquemas,
            sql: self.sql,
            values: valores
          })
      end
      self.nombres_de_columna = cq.first.nombres_de_columnas
      
      return Informe.array_a_csv(cq)
    else # ruby code
      cq = CustomQuery.buscar({
          ruby: self.metodo,
          values: valores
        })

      self.nombres_de_columna = cq.first.nombres_de_columnas
      return Informe.array_a_csv(cq)
    end
  end

  def self.array_a_csv(arg_custom_query)
    
    CSV.generate(col_sep: "\t") do |csv|
      csv << arg_custom_query.first.nombres_de_columnas
        arg_custom_query.each do |r|
          csv << r.attributes.values_at(*arg_custom_query.first.nombres_de_columnas)
      end
    end
  end

end
