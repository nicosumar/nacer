class CorregirTipoDePrestacionEnNotificaciones < ActiveRecord::Migration

  def up
    ObjetoDeLaPrestacion.find_by(codigo: "N003").
      update_attributes!({ tipo_de_prestacion: TipoDePrestacion.find_by(codigo: "NT")})
    ObjetoDeLaPrestacion.find_by(codigo: "N001").
      update_attributes!({ tipo_de_prestacion: TipoDePrestacion.find_by(codigo: "NT")})
  end

  def down
    ObjetoDeLaPrestacion.find_by(codigo: "N003").
      update_attributes!({ tipo_de_prestacion: TipoDePrestacion.find_by(codigo: "RO")})
    ObjetoDeLaPrestacion.find_by(codigo: "N001").
      update_attributes!({ tipo_de_prestacion: TipoDePrestacion.find_by(codigo: "RO")})
  end

end
