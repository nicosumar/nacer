# -*- encoding : utf-8 -*-
class Ability
  include CanCan::Ability

  def initialize(user)
    cannot :manage, :all

    if user.in_group? :administradores
      can :manage, :all
    end

    if user.in_group? :operaciones
      can :manage, Contacto
      can :read, NovedadDelAfiliado
      can :read, Efector
      can :read, Referente
      can :read, Afiliado
      can :read, ConvenioDeGestion
      can :read, ConvenioDeAdministracion
      can :read, Addenda
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
      can :read, Addenda
    end

    if user.in_group? :convenios
      can :manage, ConvenioDeGestion
      can :manage, ConvenioDeAdministracion
      can :manage, Addenda
      can :manage, Referente
      can :manage, Contacto
      can :manage, Efector
    end

    if user.in_group? :inscripcion_uad
      can :read, Afiliado
      can :manage, NovedadDelAfiliado
    end

    if user.in_group? :auditoria_control
      can :manage, Contacto
      can :read, Efector
      can :read, Referente
      can :read, ConvenioDeAdministracion
      can :read, ConvenioDeGestion
      can :read, Addenda
    end

  end
end
