# -*- encoding : utf-8 -*-
class ProcesoDeDatosExternos < ActiveRecord::Base
  # Seguridad de asignaciones masivas
  attr_accessible :archivo_de_datos, :notificar_por_email, :observaciones, :tipo_de_proceso_id

  # Asociaciones
  belongs_to :tipo_de_proceso

  # Validaciones
  validates :archivo_de_datos, :presence => {:message => "Debe seleccionar un archivo para procesar."}
  validates :tipo_de_proceso_id, :presence => true
  validates :archivo_de_datos_fingerprint, :uniqueness => {:message => "El archivo seleccionado para procesar ya fue asignado a otro proceso."}

  # Paperclip
  has_attached_file(
      :archivo_de_datos,
      :styles => lambda {|adjunto| { :text => { :tipo_de_proceso => adjunto.instance.tipo_de_proceso } } },
      :processors => [:datos_externos]
    )
  validates_attachment_content_type(
      :archivo_de_datos, :content_type => ["text/plain", "text/csv"],
      :message => "El contenido del archivo a procesar no es el esperado (texto plano o CSV)."
    )
  before_post_process :valid? # Solo ejecutamos el postprocesador cuando es válido el objeto

  def procesar
    # Marcamos el inicio del proceso
    self.proceso_iniciado = Time.now
    self.save!(:validate => false)

    # Llamamos al método de procesamiento de datos externos específico del modelo que corresponde al tipo de proceso
    begin
      eval(tipo_de_proceso.modelo_de_datos).procesar_datos_externos(tabla_de_preprocesamiento)
    rescue Exception => e
      self.ultimo_fallo = Time.now
      self.excepcion = e.to_s
      self.save!(:validate => false)
      raise e
      return
    end

    # Marcamos la finalización del proceso
    self.proceso_finalizado = Time.now
    self.save!(:validate => false)
  end

  def eliminar_tabla_de_preprocesamiento
    ActiveRecord::Base.connection.execute <<-SQL
      DROP TABLE IF EXISTS "procesos"."#{tabla_de_preprocesamiento}" CASCADE;
    SQL
  end

  def crear_tabla_de_preprocesamiento
    ActiveRecord::Base.connection.execute <<-SQL
      CREATE TABLE "procesos"."#{tabla_de_preprocesamiento}" (
        numero_de_linea integer PRIMARY KEY,
        formato_valido boolean,
        errores_de_formato text,
        linea text,
        linea_procesada timestamp without time zone,
        a_persistir boolean DEFAULT 'f'::boolean,
        objeto_serializado text,
        mensajes_de_proceso text
      );
    SQL
  end

  def porcentaje_de_avance
    return 0.0 unless tabla_de_preprocesamiento.present?

    porcentaje = ActiveRecord::Base.connection.execute <<-SQL
      SELECT (COUNT(linea_procesada)::float / COUNT(*)::float * 100.0::float) AS "porcentaje"
        FROM "procesos"."#{tabla_de_preprocesamiento}";
        WHERE formato_valido;
    SQL

    return "%.1f" % porcentaje.values[0][0].to_f
  end

  def modificable?
    # Un proceso puede modificarse si no está en procesamiento y todavía no fue aplicado
    !proceso_aplicado && (proceso_solicitado.nil? || proceso_finalizado.present?)
  end

  def cantidad_de_lineas_totales
    if self.tabla_de_preprocesamiento.present?
      cantidad = ActiveRecord::Base.connection.execute <<-SQL
        SELECT COUNT(*) AS "cantidad"
          FROM "procesos"."#{tabla_de_preprocesamiento}";
      SQL
      return cantidad.values[0][0].to_i
    end
    return 0
  end

  def cantidad_de_lineas_validas
    if self.tabla_de_preprocesamiento.present?
      cantidad = ActiveRecord::Base.connection.execute <<-SQL
        SELECT COUNT(*) AS "cantidad"
          FROM "procesos"."#{tabla_de_preprocesamiento}"
          WHERE formato_valido;
      SQL
      return cantidad.values[0][0].to_i
    end
    return 0
  end

end
