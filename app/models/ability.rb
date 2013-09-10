class Ability
  include CanCan::Ability


  def initialize(user)
    alias_action :show, to: :read
    user ||= User.new

    if user.has_role? :admin
      can :publish, Document, state: 'pending publication'

    elsif user.has_role? :author
      can :manage, Document, user_id: user.id,  state: ['in creation', 'in rework']
      can :read, Document, user_id: user.id, state: ['pending review','pending publication']
      can :read, Document, state: 'published'
      #can :read, Comment

    elsif user.has_role? :reviewer
      can [:read, :show], Document, state: ['pending review','pending publication', 'published', 'in rework']
      can [:send_for_publication, :send_for_rework], Document, state: 'pending review'
      can [:create, :read], Comment
    else
      can :read, Document, state: 'published'
    end
  end
end
