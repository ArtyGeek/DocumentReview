# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'ROLES'


ENV['ROLES'].split(',').each do |role|
  Role.find_or_create_by_name(role)
  puts 'role: ' << role
end

puts 'DEFAULT USERS'


Role.all.each do |role|
  puts role.inspect
  @user = User.create(name: role.name, email: role.name+'@demo.app', password:  role.name+'12345', password_confirmation:  role.name+'12345')
  puts 'user ' << @user.name
  puts 'password: '+role.name+'12345'
  @user.add_user_role role.name
end

