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

puts 'SAMPLE DATA'


30.times do
  @document = Document.create(title: 'Lorem Ipsum', description: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', user_id: User.with_role(:author).shuffle.first.id)
  file = File.open(Rails.root.join('spec', 'factories', 'sample_doc.pdf'))
  @attachment = @document.attachments.build
  @attachment.file = file
  file.close
  @attachment.save!
  @document.save!
end
puts '30 basic documents done'

25.times {Document.with_state(:in_creation).shuffle.first.send_for_review}
puts '25 documents in review done'

7.times do
  @document = Document.with_state(:pending_review).shuffle.first
  3.times do
    @document.comments.create(content: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit.', user_id: User.with_role(:reviewer).shuffle.first.id)
  end
  @document.send_for_rework
end
puts '7 documents in review done'

 13.times {Document.with_state(:pending_review).shuffle.first.send_for_publication}
 puts '13 documents in publication done'
 10.times {Document.with_state(:pending_publication).shuffle.first.publish}
 puts '10 published documents done'





