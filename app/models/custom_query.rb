# -*- encoding : utf-8 -*-
require 'usa_multi_tenant'
class CustomQuery < ActiveRecord::Base
  extend UsaMultiTenant

  def self.buscar(*args)
  	#ActiveRecrod::Base.execute <<-SQL
  	#	CREATE OR REPLACE TEMPORARY VIEW customes_queryes AS
    #      SELECT 1
  	#SQL
  	ActiveRecord::Base.connection.execute "CREATE OR REPLACE TEMPORARY VIEW customes_queryes AS SELECT 1"

  	self.find_by_sql "Select 'a' a, 'b' b"


  end
end