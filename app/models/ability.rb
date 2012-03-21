class Ability
  include CanCan::Ability

  def initialize(user)
    cannot :manage, :all

    if user.in_group? :administradores then
      can :manage, :all
    end

    if user.in_group? :operaciones then
      can :read, :all
      can :manage, Efector
      can :manage, Contacto
    end

    if user.in_group? :facturación then
      can :read, :all
      can :manage, AsignacionDeNomenclador
      can :manage, AsignacionDePrecios
      can :manage, Contacto
      can :manage, Nomenclador
      can :manage, Prestacion
      can :manage, Liquidacion
      can :manage, CuasiFactura
      can :manage, RenglonDeCuasiFactura
      can :manage, RegistroDePrestacion
      can :manage, RegistroDeDatoAdicional
    end

    if user.in_group? :convenios then
      can :read, :all
      can :manage, Addenda
      can :manage, Contacto
      can :manage, ConvenioDeAdministracion
      can :manage, ConvenioDeGestion
      can :manage, Referente
    end

  end
end
