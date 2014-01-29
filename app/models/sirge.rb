class Sirge < ActiveRecord::Base

  belongs_to :efector
  belongs_to :efector_cesion

  attr_accessible :codigo_gasto, :concepto, :efector, :efector_cesion, :fecha_gasto, :monto, :numero_comprobante_gasto, :periodo

  validates_presence_of :codigo_gasto, :efector, :efector_cesion, :fecha_gasto, :monto, :periodo

  def self.cargar_aplicacion_de_fondos(anio, mes)

    ruta = "lib/tasks/datos/sirge/#{anio}-#{mes}/crudo_aplicacion_de_fondos" 
    archivos = Dir.glob("#{ruta}/**/*").delete_if { |a| a.count('.') == 0 }

              
    arr_codigos_de_gastos = ['1.1','1.2','1.3',
                             '2.1','2.2','2.3',
                             '3.1','3.2',
                             '4.1','4.2','4.3',
                             '5.1','5.2','5.3',
                             '6.1','6.2','6.3',
                             '7.1'
                           ]

    ActiveRecord::Base.connection.schema_search_path = "public"
    
    archivos.each do |ra|
      @rutayarchivo = ra
      puts "archivo: #{@rutayarchivo}"
      ActiveRecord::Base.transaction do

        #begin
          # Trato de abrirlo con spreedsheet
          book = Spreadsheet.open @rutayarchivo
          sheet = book.worksheet 0

          sheet.each 3 do |row|

            # -------------------------------------------------
            # Verificar la condicion de terminación 
            break if row[1] == "CUIE"
            # -------------------------------------------------
            
            # Si la fila que tiene cuie, mes de reporte y anio de reporte tienen algo, busco para procesar
            if row[1].present? and row[2].present? and row[3].present?
              e = Efector.where("cuie = trim('#{row[1]}')")

              if e.size == 1 
                efector_id = e.first.id
              else
                raise ActiveRecord::Rollback, "No se encontro el efector en la fila #{row.idx+1}"
              end

              begin
                puts "fila #{row.idx} procesada"
                puts "row 2 : #{ row[2]}"
                puts "row 3 : #{ row[3]}"

                #fecha_gasto = "2013-"+ row[2].to_s + "-" + Time.days_in_month(row[2], row[3]) #el ultimo dia de cada periodo de rendicion
                if Time.days_in_month(row[2], row[3]) == 29
                  fecha_gasto = 28
                else
                  fecha_gasto = Time.days_in_month(row[2], row[3]) #el ultimo dia de cada periodo de rendicion
                end

                  
                periodo = row[3].to_s+"-"+row[2].to_s
                numero_comprobante_gasto = "NULL"
              rescue Exception => ex
                fecha_gasto = Time.days_in_month(row[2].to_s.gsub(/[^0-9]/i, ''), row[3].to_s.gsub(/[^0-9]/i, '')) #el ultimo dia de cada periodo de rendicion
                periodo = row[3].to_s.gsub(/[^0-9]/i, '')+" "+row[2].to_s.gsub(/[^0-9]/i, '')
              end
    #  Sirge.cargar_aplicacion_de_fondos("2014", "01")

              i = 4
              while i <= 21
                codigo_gasto = arr_codigos_de_gastos[i-4]
                efector_cesion = ""
                monto = row[i].present? ? row[i] : "NULL"

                ActiveRecord::Base.connection.execute "INSERT INTO  public.sirge  \n"+
                      "( efector_id, fecha_gasto,           periodo, numero_comprobante_gasto, codigo_gasto, efector_cesion_id, monto, concepto, created_at, updated_at ) \n"+
                      "VALUES \n"+ 
                      "( #{efector_id}, date('2013-#{row[2]}-#{fecha_gasto}'), '#{periodo}', NULL                     ,'#{codigo_gasto}', NULL           , #{monto}, ''   , now()     , now() );"

                i+= 1
              end

            end

          end 
          
        #rescue Exception => e
        #    raise "No pudo abrirse el archivo del periodo indicado. Detalles: #{e.message}"
        #end #End rescue

      end #end transaccion
    end # end itera archivos

  end
end
