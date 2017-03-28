# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class PrestacionPrincipalAutorizada < ActiveRecord::Base
  
   
  attr_readonly :prestacion_principal_id , :nombre, :codigo
  def self.efector_y_fecha(efector_id, fecha = Date.today)
    qres = ActiveRecord::Base.connection.exec_query( <<-SQL
    WITH prestaciones_desagrupadas as (
      SELECT DISTINCT       
      p.prestacion_principal_id
      FROM
	    prestaciones_pdss pp 
      join prestaciones_pdss_autorizadas ppa on 
       (
          ppa.prestacion_pdss_id = pp.id
          and  ppa.efector_id =  #{efector_id}
          AND  ppa.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (ppa.fecha_de_finalizacion IS NULL OR ppa.fecha_de_finalizacion >= '#{fecha.iso8601}')
          and ppa.autorizante_al_alta_type IS NOT NULL	    
        )        
	    JOIN prestaciones_prestaciones_pdss ppp ON pp.id = ppp.prestacion_pdss_id
      JOIN prestaciones p ON p.id = ppp.prestacion_id
	   )
      Select distinct 
        pp.id,
        pp.nombre,
        pp.codigo ,
         Case when pd.prestacion_principal_id is not null  then true  else false end "Autorizada"
      from prestaciones_principales pp
      left join prestaciones_desagrupadas pd on pp.id = pd.prestacion_principal_id
      where pp.activa =true ;
      SQL
    )
    
    prestaciones = []
     PrestacionPrincipal.where(activa:true).each do |p|
      prestaciones << p.attributes.merge!(:prestaciones_principales => self.obtener_prestaciones_principales(qres.columns, qres.rows.dup.keep_if{|r| r[0] == p.id.to_s}))  
     end
  # byebug
    return prestaciones
    
  end
  def self.obtener_prestaciones_principales(nombres, valores)
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
