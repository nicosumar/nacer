class Ability
  include CanCan::Ability

  def initialize(user)
    cannot :manage, :all

    if user.in_group? :administradores then
      can :manage, :all
    end

    if user.in_group? :operaciones then
      can :manage, Contacto
      can :manage, Efector
      can :read, Referente
      can :read, Afiliado
      can :manage, NovedadDelAfiliado
    end

    if user.in_group? :facturación then
      can :read, Efector
      can :read, Referente
      can :read, ConvenioDeAdministracion
      can :read, ConvenioDeGestion
      can :manage, Contacto
      can :manage, Liquidacion
      can :manage, CuasiFactura
    end

    if user.in_group? :convenios then
      can :read, Efector
      can :manage, Addenda
      can :manage, Contacto
      can :manage, ConvenioDeAdministracion
      can :manage, ConvenioDeGestion
      can :manage, Referente
    end

    if user.in_group? :inscripción then
      can :read, Afiliado
      can :manage, NovedadDelAfiliado
    end

  end
end
