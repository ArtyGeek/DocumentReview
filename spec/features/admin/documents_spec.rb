require 'spec_helper'

describe 'Admin user', js: true do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:document) { FactoryGirl.create(:document_pending_publication)  }
  let(:sign_in) {
    document
    visit new_user_session_path
    fill_in 'user[email]', with: admin.email
    fill_in 'user[password]', with: '12345678'
    click_button 'Sign in'
    find('.nav').should have_link('Admin')
    visit admin_dashboard_path
  }

  describe ' when publishes document' do

    it 'goes to documents tab' do
      sign_in
      click_link 'Documents to publication'
      save_and_open_page
      page.should have_content document.title, document.state
    end


    it 'goes to page of document to publish' do
      sign_in
      click_link 'Documents to publication'
      find('tr', text: document.title).click_link 'Show'
      page.should have_content document.title, document.state, document.description
    end


    it 'publishes document' do
      sign_in
      click_link 'Documents to publication'
      find('tr', text: document.title).click_link 'Show'
      page.should have_content document.title, document.state, document.description
      click_link 'Publish'
      page.should have_content 'Document was successfully published'
    end

  end
end