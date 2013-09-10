class User < ActiveRecord::Base
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :documents
  has_many :comments

  after_create do
    self.add_role :default
  end

  def add_user_role role
    self.transaction do
      self.roles.each do |role|
        self.remove_role role.name
        end
      self.add_role role
    end
  end

end
