# -*- encoding : utf-8 -*-
class Ability
  include CanCan::Ability

  def initialize(user)
    cannot :manage, :all

    if user.in_group? :administradores
      can :manage, :all
    end

    if user.in_group? :facturacion
      can :manage, Liquidacion
      can :manage, CuasiFactura
      can :manage, RegistroDePrestacion
      can :manage, RenglonDeCuasiFactura
      can :manage, RegistroDeDatoAdicional
      can :manage, Contacto
      can :read, Efector
      can :read, Referente
      can :read, ConvenioDeAdministracion
      can :read, ConvenioDeGestion
      can :read, ConvenioDeAdministracionSumar
      can :read, ConvenioDeGestionSumar
      can :read, Addenda
      can :read, AddendaSumar
      can :read, PrestacionAutorizada
      can :manage, LiquidacionSumar
      can :manage, LiquidacionSumarAnexoAdministrativo
      can :manage, AnexoAdministrativoPrestacion
      can :read, LiquidacionSumarAnexoMedico
      can :read, AnexoMedicoPrestacion
    end

    if user.in_group? :operaciones
      can :manage, Contacto
      can :read, NovedadDelAfiliado
      can :read, Efector
      can :read, Referente
      can :read, Afiliado
      can :read, ConvenioDeGestion
      can :read, ConvenioDeAdministracion
      can :read, ConvenioDeAdministracionSumar
      can :read, ConvenioDeGestionSumar
      can :read, Addenda
      can :read, AddendaSumar
      can :read, PrestacionAutorizada
    end

    if user.in_group? :auditoria_medica
      can :manage, Contacto
      can :read, Afiliado
      can :read, Efector
      can :read, Referente
      can :read, ConvenioDeAdministracion
      can :read, ConvenioDeGestion
      can :read, ConvenioDeAdministracionSumar
      can :read, ConvenioDeGestionSumar
      can :read, Addenda
      can :read, AddendaSumar
      can :read, PrestacionAutorizada
      can :manage, LiquidacionSumarAnexoMedico
      can :manage, AnexoMedicoPrestacion
      can :read, LiquidacionSumarAnexoAdministrativo
      can :read, AnexoAdministrativoPrestacion
    end

    if user.in_group? :convenios
      can :read, ConvenioDeGestion
      can :read, ConvenioDeAdministracion
      can :manage, ConvenioDeAdministracionSumar
      can :manage, ConvenioDeGestionSumar
      can :read, Addenda
      can :manage, AddendaSumar
      can :manage, Referente
      can :manage, Contacto
      can :read, Efector
      can :update, Efector
      can :read, PrestacionAutorizada
    end

    if user.in_group? :auditoria_control
      can :manage, Contacto
      can :read, Efector
      can :read, Referente
      can :read, ConvenioDeAdministracion
      can :read, ConvenioDeGestion
      can :read, ConvenioDeAdministracionSumar
      can :read, ConvenioDeGestionSumar
      can :read, Addenda
      can :read, AddendaSumar
      can :read, PrestacionAutorizada
    end

    if user.in_group? :coordinacion
      can :manage, Contacto
      can :read, Efector
      can :read, Referente
      can :read, ConvenioDeAdministracion
      can :read, ConvenioDeGestion
      can :read, ConvenioDeAdministracionSumar
      can :read, ConvenioDeGestionSumar
      can :read, Addenda
      can :read, AddendaSumar
      can :read, PrestacionAutorizada
    end

    if user.in_group? :planificacion
      can :manage, Contacto
      can :read, Efector
      can :read, Referente
      can :read, ConvenioDeAdministracion
      can :read, ConvenioDeGestion
      can :read, ConvenioDeAdministracionSumar
      can :read, ConvenioDeGestionSumar
      can :read, Addenda
      can :read, AddendaSumar
      can :read, PrestacionAutorizada
    end

    if user.in_group? :inscripcion_uad
      can :read, Afiliado
      can :manage, NovedadDelAfiliado
    end

    if user.in_group? :facturacion_uad
      can :read, Afiliado
      can :read, NovedadDelAfiliado
      can :manage, PrestacionBrindada
      can :manage, DatoReportableAsociado
    end

    if user.in_group? :capacitacion
      can :manage, Contacto
      can :manage, NovedadDelAfiliado
      can :read, Afiliado
      can :read, Efector
      can :read, Referente
      can :read, ConvenioDeAdministracion
      can :read, ConvenioDeGestion
      can :read, ConvenioDeAdministracionSumar
      can :read, ConvenioDeGestionSumar
      can :read, Addenda
      can :read, AddendaSumar
      can :read, PrestacionAutorizada
      can :read, UnidadDeAltaDeDatos
      can :read, User
    end

  end
end
