class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true
  scopify
  after_destroy :check_precense_of_all_roles

  def check_precense_of_all_roles
    @roles = Role.pluck(:name)
    ENV['ROLES'].split(',').each {|role| Role.create(name: role) unless @roles.include? role}
  end
end
