class Ability
  include CanCan::Ability

  def initialize(user)
    cannot :manage, :all

    if user.in_group? :administradores then
      can :manage, :all
    end

    if user.in_group? :operaciones then
      can :manage, Efector
      can :manage, Contacto
      can :read, Referente
      can :read, Afiliado
      can :manage, NovedadDelAfiliado
    end

    if user.in_group? :facturación then
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
      can :read, Efector
    end

    if user.in_group? :inscripción then
      can :read, Afiliado
      can :manage, NovedadDelAfiliado
    end

  end
end
