require 'spec_helper'

describe 'Check out dashboard', js:true do
  let(:admin) {FactoryGirl.create(:admin)}
  let(:document_pending_publication) {FactoryGirl.create(:document_pending_publication)}
  let(:document) {FactoryGirl.create(:document)}
  let(:sign_in) {
    visit new_user_session_path
    fill_in 'user[email]', with: admin.email
    fill_in 'user[password]', with: '12345678'
    click_button 'Sign in'
    find('.nav').should have_link('Admin')
    document_pending_publication
    document
    visit admin_dashboard_path
  }

  it 'checks info on dashboard'   do
    sign_in
    page.should have_content('Admin Dashboard')
    ENV['ROLES'].split(',').each { |role| page.should have_content role }
    find('tr', text: 'admin').should have_content('1')
    find('tr', text: 'pending_publication').should have_content('1')
    find('tr', text: 'in_creation').should have_content('1')
  end

  it 'checks users page' do
    sign_in
    click_link('Users Managment')
    find('tr', text: admin.name).should have_content(admin.email, admin.sign_in_count, admin.last_sign_in_at)
  end

  it 'checks pending for publication documents page' do
    sign_in
    click_link('Documents to publication')
    find('tr', text: 'pending publication').should have_content(document_pending_publication.title)
  end
end




