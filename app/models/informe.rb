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
  attr_accessible :formato
  attr_accessible :informes_filtros_attributes

  attr_accessor :nombres_de_columna

  #"Sexy" validations
  validates :titulo, presence: true
  validates :nombre_partial, presence: true
  validates :formato, presence: true

  validates_associated :informes_filtros

  # Los informes que se ejecutan con codigo sql siempre deben devolver 
  # un array de objetos de tipo CustomQuery, sea cual fuese el origen de los datos
  # del informe.
  # 
  # Para "falsear" el objeto custom query, si el origen fuese por ejemplo un array 
  # estatico, o un excel, usar el siguiente codigo en el metodo que devuelve los resultados:
  # 
  #   resp = []
  #   resultado_del_query.each do |r|
  #     fila_1 = CustomQuery.new
  #
  #     fila_1.class.module_eval { attr_accessor :codigo_de_prestacion}   # el attr_accessor es el nombre de la columna que se mostrará en la tabla
  #     fila_1.class.module_eval { attr_accessor :codigo_de_diagnostico}  # hay que crear un attr_accesor por cada dato mostrado
  #     fila_1.class.module_eval { attr_accessor :cantidad}
  #     fila_1.class.module_eval { attr_accessor :total}
  #
  #     fila_1.codigo_de_prestacion = r.prestacion_codigo                 # Despues hay que asignarle los valores que correspondan
  #     fila_1.codigo_de_diagnostico = r.diagnostico
  #     fila_1.cantidad = r.cantidad_total
  #     fila_1.total = r.total
  #
  #     resp << fila_1
  #   end
  #   return resp
  #   
  #   Si el resultado ya viniese de un CustomQuery, igual hay que hacer el mismo procedimiento. No es valido lo siguiente
  # 
  #   resp = []
  #   resultado_del_custom_query.each do |r|
  #     resp << r
  #   end
  #   return resp
  # 
  #   Si bien funciona, el modelo de Informe.rb espera que los nombres de columnas sean variables de instancia
  #   y no attributos de la clase como responde usualmente el custom query.
  # 
  #   Esto es porque no me dio mas la cabeza para ver como mapear los nombres de columnas contra los atributos
  #   de la clase en el caso que los resultados a mostrar en el informe NO viniesen de una instancia de CustomQuery.
  # 
  #   Es un poco más de trabajo pero da la posibilidad de sacar datos de un excel o de un array hardcodeado,
  #   o de lugares que no vengan estrictamente de la base de datos sin tener que estar adivinando que atributos
  #   son los que debe mostrar en la tabla
  
  
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

      self.nombres_de_columna = (cq.first.instance_variables - [:@attributes, :@relation, :@changed_attributes, 
                                :@previously_changed, :@attributes_cache, :@association_cache, 
                                :@aggregation_cache, :@marked_for_destruction, :@destroyed, 
                                :@readonly, :@new_record]).map { |c| c.to_s.tr('@','').tr('_',' ').capitalize}
      return cq
    end

  end


end
