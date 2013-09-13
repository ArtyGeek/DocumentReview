require 'spec_helper'

describe 'Admin user', js: true do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:users) { 5.times.map { FactoryGirl.create(:user) }  }
  let(:roles) { ENV["ROLES"].split(',').each {|role| Role.find_or_create_by_name role}}
  let(:sign_in) {
    roles
    users
    visit new_user_session_path
    fill_in 'user[email]', with: admin.email
    fill_in 'user[password]', with: '12345678'
    click_button 'Sign in'
    find('.nav').should have_link('Admin')
    visit admin_dashboard_path
  }

  it 'goes to users tab' do
    sign_in
    click_link 'Users Managment'
    users.each do |user|
      find('tr', text: user.email).should have_content user.name, user.roles.first, user.sign_in_count
      find('tr', text: user.email).should have_link('Show')
      find('tr', text: user.email).should have_link('Edit')
      find('tr', text: user.email).should have_link('Destroy')
    end
  end

  it 'goes to specific show user page' do
    sign_in
    click_link 'Users Managment'
    random_user = users.shuffle.first

    visit admin_user_path(random_user.id)
    page.should have_content random_user.name, random_user.roles.first.name, random_user.email
    @roles = ENV['ROLES'].split(',')
    @roles.delete(random_user.roles.first.name)

    @roles.each do |role|
      page.should have_link 'Add role '+role
    end
  end

  it 'deletes specific user' do
    sign_in
    click_link 'Users Managment'
    random_user = users.shuffle.first
    find('tr', text: random_user.email).click_link 'Destroy'
    page.driver.browser.switch_to.alert.accept
    page.should have_content 'User was successfully destroyed.'
  end

  it 'creates new user with valid credentials' do
    sign_in
    click_link 'Users Managment'
    click_link 'New User'
    fill_in 'user[name]', with: 'Qwerty'
    fill_in 'user[email]', with: 'qwerty@demo.app'
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'
    click_button 'Update'
    page.should have_content 'User was successfully created.', 'Qwerty', 'qwerty@demo.app'
  end

  it 'tries to create new user with invalid credentials' do
    random_user = users.shuffle.first
    sign_in
    click_link 'Users Managment'
    click_link 'New User'
    fill_in 'user[name]', with: random_user.name
    fill_in 'user[email]', with: random_user.email
    fill_in 'user[password]', with: random_user.password
    fill_in 'user[password_confirmation]', with: random_user.password
    click_button 'Update'
    page.should have_content 'Please review the problems below:', 'Email', 'has already been taken'
  end

  it 'edits existing user with valid credentials' do
    random_user = users.shuffle.first
    sign_in
    click_link 'Users Managment'
    find('tr', text: random_user.name).click_link 'Edit'
    fill_in 'user[name]', with: random_user.name
    fill_in 'user[email]', with: random_user.email
    fill_in 'user[password]', with: random_user.password
    fill_in 'user[password_confirmation]', with: random_user.password
    click_button 'Update'
    page.should have_content 'User was successfully updated.'
  end

  it 'edits existing user with invalid credentials' do
    random_user = users.shuffle.first
    sign_in
    click_link 'Users Managment'
    find('tr', text: random_user.name).click_link 'Edit'
    fill_in 'user[name]', with: random_user.name
    fill_in 'user[email]', with: random_user.email
    fill_in 'user[password]', with: random_user.password
    fill_in 'user[password_confirmation]', with: 'wron_pass_confirmation'
    click_button 'Update'
    page.should have_content 'Please review the problems below:', 'Password confirmation', "doesn't match Password"
  end


end
