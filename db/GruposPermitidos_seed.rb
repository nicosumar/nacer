# -*- encoding : utf-8 -*-
# Datos precargados al inicializar el sistema
GrupoPermitido.create!(
  [
    { :grupo_poblacional_id => 1, :grupo_pdss_id => GrupoPdss.where(codigo: "2.1").first.id, :sexo_id => 2 },
    { :grupo_poblacional_id => 1, :grupo_pdss_id => GrupoPdss.where(codigo: "2.2").first.id, :sexo_id => 2 },
    { :grupo_poblacional_id => 1, :grupo_pdss_id => GrupoPdss.where(codigo: "2.3").first.id, :sexo_id => 2 },
    { :grupo_poblacional_id => 1, :grupo_pdss_id => GrupoPdss.where(codigo: "2.4").first.id, :sexo_id => 2 },
    { :grupo_poblacional_id => 1, :grupo_pdss_id => GrupoPdss.where(codigo: "2.5").first.id, :sexo_id => 2 },
    { :grupo_poblacional_id => 1, :grupo_pdss_id => GrupoPdss.where(codigo: "2.6").first.id, :sexo_id => 2 },
    { :grupo_poblacional_id => 1, :grupo_pdss_id => GrupoPdss.where(codigo: "2.7").first.id, :sexo_id => 2 },
    { :grupo_poblacional_id => 1, :grupo_pdss_id => GrupoPdss.where(codigo: "2.8").first.id, :sexo_id => 2 },
    { :grupo_poblacional_id => 1, :grupo_pdss_id => GrupoPdss.where(codigo: "2.1").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 1, :grupo_pdss_id => GrupoPdss.where(codigo: "2.2").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 1, :grupo_pdss_id => GrupoPdss.where(codigo: "2.3").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 1, :grupo_pdss_id => GrupoPdss.where(codigo: "2.4").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 1, :grupo_pdss_id => GrupoPdss.where(codigo: "2.5").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 1, :grupo_pdss_id => GrupoPdss.where(codigo: "2.6").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 1, :grupo_pdss_id => GrupoPdss.where(codigo: "2.7").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 1, :grupo_pdss_id => GrupoPdss.where(codigo: "2.8").first.id, :sexo_id => 1 },

    { :grupo_poblacional_id => 2, :grupo_pdss_id => GrupoPdss.where(codigo: "3.1").first.id, :sexo_id => 2 },
    { :grupo_poblacional_id => 2, :grupo_pdss_id => GrupoPdss.where(codigo: "3.2").first.id, :sexo_id => 2 },
    { :grupo_poblacional_id => 2, :grupo_pdss_id => GrupoPdss.where(codigo: "3.3").first.id, :sexo_id => 2 },
    { :grupo_poblacional_id => 2, :grupo_pdss_id => GrupoPdss.where(codigo: "3.4").first.id, :sexo_id => 2 },
    { :grupo_poblacional_id => 2, :grupo_pdss_id => GrupoPdss.where(codigo: "3.1").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 2, :grupo_pdss_id => GrupoPdss.where(codigo: "3.2").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 2, :grupo_pdss_id => GrupoPdss.where(codigo: "3.3").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 2, :grupo_pdss_id => GrupoPdss.where(codigo: "3.4").first.id, :sexo_id => 1 },

    { :grupo_poblacional_id => 3, :grupo_pdss_id => GrupoPdss.where(codigo: "4.1").first.id, :sexo_id => 2 },
    { :grupo_poblacional_id => 3, :grupo_pdss_id => GrupoPdss.where(codigo: "4.2").first.id, :sexo_id => 2 },
    { :grupo_poblacional_id => 3, :grupo_pdss_id => GrupoPdss.where(codigo: "4.3").first.id, :sexo_id => 2 },
    { :grupo_poblacional_id => 3, :grupo_pdss_id => GrupoPdss.where(codigo: "4.4").first.id, :sexo_id => 2 },
    { :grupo_poblacional_id => 3, :grupo_pdss_id => GrupoPdss.where(codigo: "4.1").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 3, :grupo_pdss_id => GrupoPdss.where(codigo: "4.2").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 3, :grupo_pdss_id => GrupoPdss.where(codigo: "4.3").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 3, :grupo_pdss_id => GrupoPdss.where(codigo: "4.4").first.id, :sexo_id => 1 },

    { :grupo_poblacional_id => 3, :grupo_pdss_id => GrupoPdss.where(codigo: "1.1").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 3, :grupo_pdss_id => GrupoPdss.where(codigo: "1.2").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 3, :grupo_pdss_id => GrupoPdss.where(codigo: "1.3").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 3, :grupo_pdss_id => GrupoPdss.where(codigo: "1.4").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 3, :grupo_pdss_id => GrupoPdss.where(codigo: "1.5").first.id, :sexo_id => 1 },

    { :grupo_poblacional_id => 6, :grupo_pdss_id => GrupoPdss.where(codigo: "1.1").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 6, :grupo_pdss_id => GrupoPdss.where(codigo: "1.2").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 6, :grupo_pdss_id => GrupoPdss.where(codigo: "1.3").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 6, :grupo_pdss_id => GrupoPdss.where(codigo: "1.4").first.id, :sexo_id => 1 },
    { :grupo_poblacional_id => 6, :grupo_pdss_id => GrupoPdss.where(codigo: "1.5").first.id, :sexo_id => 1 },

    { :grupo_poblacional_id => 6, :grupo_pdss_id => GrupoPdss.where(codigo: "5.1").first.id, :sexo_id => 2 },    
    { :grupo_poblacional_id => 6, :grupo_pdss_id => GrupoPdss.where(codigo: "5.1").first.id, :sexo_id => 1 },

    { :grupo_poblacional_id => 1, :grupo_pdss_id => GrupoPdss.where(codigo: "7.1").first.id, :sexo_id => 2 },
    { :grupo_poblacional_id => 1, :grupo_pdss_id => GrupoPdss.where(codigo: "7.1").first.id, :sexo_id => 1 },

    { :grupo_poblacional_id => 2, :grupo_pdss_id => GrupoPdss.where(codigo: "7.1").first.id, :sexo_id => 2 },
    { :grupo_poblacional_id => 2, :grupo_pdss_id => GrupoPdss.where(codigo: "7.1").first.id, :sexo_id => 1 },

    { :grupo_poblacional_id => 3, :grupo_pdss_id => GrupoPdss.where(codigo: "7.1").first.id, :sexo_id => 2 },
    { :grupo_poblacional_id => 3, :grupo_pdss_id => GrupoPdss.where(codigo: "7.1").first.id, :sexo_id => 1 },

    { :grupo_poblacional_id => 6, :grupo_pdss_id => GrupoPdss.where(codigo: "7.1").first.id, :sexo_id => 2 },
    { :grupo_poblacional_id => 6, :grupo_pdss_id => GrupoPdss.where(codigo: "7.1").first.id, :sexo_id => 1 }
  ]
)