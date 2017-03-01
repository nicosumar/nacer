#!/usr/bin/env ruby
class Particionador    
  
  attr_accessor :archivo_a_procesar

 

    def initialize

    end

    def procesar(archivo, cantidad_de_lineas)
        data = Array.new()
        files = Array.new()
        lineNum = 0
        file_num = -1
        bytes    = 0


        max_lines = cantidad_de_lineas
        @archivo_a_procesar = archivo

        filename = 'lib/tasks/datos/' + @archivo_a_procesar.to_s
        r = File.exist?(filename)
        puts 'File exists =' + r.to_s + ' ' +  filename
        file=File.open(filename,"r")
        line_count = file.readlines.size
        #file_size = File.size(filename).to_f / 1024000
        puts 'Total lines=' + line_count.to_s  #+ '   size=' + file_size.to_s + ' Mb'
        puts ' '


        file = File.open(filename,"r")
        puts '1 File open read ' + filename

        file.each{|line|
              bytes += line.length
              lineNum += 1
              data << line    

                #if bytes > max_bytes  then
                if lineNum > max_lines  then     
                      bytes = 0
                      file_num += 1
                      
        
                  puts '_2 File open write ' + file_num.to_s + '  lines ' + lineNum.to_s
                 
                  files[file_num] = "lib/tasks/datos/temp/#{file_num}.txt" 
                  File.open("lib/tasks/datos/temp/#{file_num}.txt", 'w') {|f| f.write data.join}

                 data.clear
                 lineNum = 0
                end



        }

        ## write leftovers
        file_num += 1
        puts '__3 File open write FINAL ' + file_num.to_s + '  lines ' + lineNum.to_s
            files[file_num] = "lib/tasks/datos/temp/#{file_num}.txt"  
            File.open("lib/tasks/datos/temp/#{file_num}.txt", 'w') {|f| f.write data.join}

    return files     
    end

end