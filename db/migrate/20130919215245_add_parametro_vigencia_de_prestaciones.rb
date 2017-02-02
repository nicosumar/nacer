class AddParametroVigenciaDePrestaciones < ActiveRecord::Migration
  def up
    Parametro.create!({
      :nombre => "VigenciaDeLasPrestaciones",
      :tipo_postgres => "int4",
      :tipo_ruby => "Integer",
      :valor => "120"})
  end

  def down
    Parametro.find_by_nombre("VigenciaDeLasPrestaciones").destroy
  end
end
