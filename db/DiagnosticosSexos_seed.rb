# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema

Diagnostico.find(
  (1..35).collect{|i| i} +
  (79..95).collect{|i| i} +
  (106..238).collect{|i| i} +
  (240..286).collect{|i| i} +
  (291..465).collect{|i| i} + [504]
).each do |d|
  d.sexos << Sexo.all
end

Diagnostico.find(
  [7] + (36..78).collect{|i| i} +
  (96..105).collect{|i| i} +
  (287..289).collect{|i| i} +
  (466..493).collect{|i| i}
).each do |d|
  d.sexos << Sexo.find_by_codigo("F")
end

Diagnostico.find(
  [290] + (494..503).collect{|i| i}
).each do |d|
  d.sexos << Sexo.find_by_codigo("M")
end
