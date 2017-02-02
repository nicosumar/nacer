class AgregarConceptosDeFacturacionFaltantesEnPrestaciones < ActiveRecord::Migration

  def up
    # Concepto de facturación: ID 1 - Paquete básico
    execute <<-SQL
      UPDATE prestaciones
        SET concepto_de_facturacion_id = 1
        WHERE id IN (
            815, 816, 817, 836, 837, 838, 839, 840, 841, 842, 843, 844, 845,
            846, 847, 848, 849, 850, 851, 852, 853, 854, 855, 856, 857, 858,
            859, 860, 861, 862, 863, 864, 865, 866, 867, 868, 869, 870, 871,
            872, 873, 874, 875, 876, 877, 878, 879, 880, 881, 882, 883
          );
    SQL

    # Concepto de facturación: ID 4 - CCC no catastrófica
    execute <<-SQL
      UPDATE prestaciones
        SET concepto_de_facturacion_id = 4
        WHERE id IN (
            818, 819, 820, 821, 822
          );
    SQL

    # Concepto de facturación: ID 4 - CCC catastrófica
    execute <<-SQL
      UPDATE prestaciones
        SET concepto_de_facturacion_id = 5
        WHERE id IN (
            823, 824, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834, 835
          );
    SQL

    # Tipo de tratamiento: ID 1 - Ambulatorio
    execute <<-SQL
      UPDATE prestaciones
        SET tipo_de_tratamiento_id = 1
        WHERE id IN (
            815, 816, 817, 836, 837, 838, 839, 840, 841, 842, 843, 844, 845,
            846, 847, 848, 849, 850, 851, 852, 853, 854, 855, 856, 857, 858,
            859, 860, 861, 862, 863, 864, 865, 866, 867, 868, 869, 870, 871,
            872, 873, 874, 875, 876, 877, 878, 879, 880, 881, 882, 883
          );
    SQL

    # Tipo de tratamiento: ID 3 - Quirúrgico
    execute <<-SQL
      UPDATE prestaciones
        SET tipo_de_tratamiento_id = 3
        WHERE id IN (
            818, 819, 820, 821, 822, 823, 824, 825, 826, 827, 828, 829, 830,
            831, 832, 833, 834, 835
          );
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
