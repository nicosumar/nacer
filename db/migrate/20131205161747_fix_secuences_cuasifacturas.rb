class FixSecuencesCuasifacturas < ActiveRecord::Migration
  def up
  	res = ActiveRecord::Base.connection.exec_query <<-SQL
  	  select sequence_name from information_schema.sequences where sequence_name ilike 'cuasifactura_sumar_seq_efector_id_%';
  	SQL

    res.rows.each do |r|
      if ActiveRecord::Base.connection.exec_query("select * from information_schema.sequences where sequence_name ilike '#{r[0].gsub('cuasifactura', 'cuasi_factura')}';").rows.size > 0
        execute "drop sequence #{r[0]};"
      else  
	  	  execute "alter sequence #{r[0]} rename to #{r[0].gsub("cuasifactura", "cuasi_factura")};"
      end
  	end

  end


end
