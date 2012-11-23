class Ability
  include CanCan::Ability

  def initialize(user)
    cannot :manage, :all

    if user.in_group? :administradores then
      can :manage, :all
    end

    if user.in_group? :operaciones then
      can :manage, Contacto
      can :read, NovedadDelAfiliado
      can :read, Efector
      can :read, Referente
      can :read, Afiliado
    end

    if user.in_group? :facturacion then
      can :manage, Liquidacion
      can :manage, CuasiFactura
      can :manage, Contacto
      can :read, Efector
      can :read, Referente
      can :read, ConvenioDeAdministracion
      can :read, ConvenioDeGestion
    end

    if user.in_group? :convenios then
      can :manage, ConvenioDeGestion
      can :manage, ConvenioDeAdministracion
      can :manage, Addenda
      can :manage, Referente
      can :manage, Contacto
      can :manage, Efector
    end

    if user.in_group? :inscripcion_uad then
      can :read, Afiliado
      can :manage, NovedadDelAfiliado
    end

  end
end
