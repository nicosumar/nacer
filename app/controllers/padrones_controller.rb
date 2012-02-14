class PadronesController < ApplicationController
  before_filter :user_required

  def index
    if not current_user.in_group?(:administradores)
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end

    if params[:proceso_id]
      @procesado = true
      @errores_presentes = false
      @errores = []

      case
        when params[:proceso_id] == "1"
          # Actualización del padrón de afiliados
          begin
            año, mes = params[:año_y_mes].split("-")
            primero_del_mes = Date.new(año.to_i, mes.to_i, 1)
            origen = File.new("vendor/data/#{params[:año_y_mes]}.txt", "r")
          rescue
            @errores_presentes = true
            @errores << "La fecha indicada del padrón es incorrecta, o no se subió el archivo a la carpeta correcta del servidor."
          end

          origen.each do |linea|
            # Procesar la siguiente línea del archivo
            linea.gsub!(/[\r\n]+/, '')
            atr_afiliado = Afiliado.attr_hash_desde_texto(linea)
            afiliado_id = atr_afiliado[:afiliado_id]
            begin
              afiliado = Afiliado.find(afiliado_id)
            rescue
            end
            if afiliado.nil?
              # El afiliado no existe en la versión actual (ha sido agregado al padrón)
              afiliado = Afiliado.new(atr_afiliado)
              afiliado.afiliado_id = atr_afiliado[:afiliado_id]
              if afiliado.save
                # Como el afiliado es nuevo, tenemos que agregar un registro a la tabla de 'periodos_activos' si está ACTIVO
                if afiliado.activo == "S"
                  PeriodoDeActividad.create({:afiliado_id => afiliado.afiliado_id,
                    :fecha_de_inicio => primero_del_mes,
                    :fecha_de_finalizacion => nil
                  })
                end
              else
                @errores_presentes = true
                afiliado.errors.full_messages.each do |e|
                  @errores << "Afiliado " + afiliado.afiliado_id.to_s + ": " + e
                end
              end
            else
              # El afiliado ya existe en la tabla, actualizar sus datos
              if afiliado.update_attributes(atr_afiliado)
                # Actualizar el periodo de actividad de este beneficiario
                begin
                  periodo = PeriodoDeActividad.where("afiliado_id = '#{afiliado.afiliado_id}' AND fecha_de_finalizacion IS NULL").first
                rescue
                end
                if afiliado.activo == "S"
                  if periodo.nil?
                    # Reactivar el beneficiario
                    PeriodoDeActividad.create({:afiliado_id => afiliado.afiliado_id,
                      :fecha_de_inicio => primero_del_mes,
                      :fecha_de_finalizacion => nil
                    })
                  end
                else
                  if periodo
                    # Desactivar el beneficiario
                    periodo.update_attributes({:fecha_de_finalizacion => primero_del_mes})
                  end
                end
              else
                @errores_presentes = true
                afiliado.errors.full_messages.each do |e|
                  @errores << "Afiliado " + afiliado.afiliado_id.to_s + ": " + e
                end
              end
            end
          end
        else
          @errores_presentes = true
          @errores << "Proceso no implementado"
      end
    else # no hay parámetros
      @procesos = [["Importación del padrón de afiliados", 1]]
      @proceso_id = 1
    end
  end

end
