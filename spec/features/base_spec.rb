require 'spec_helper'

describe "Home activities" do
  let(:published_document) { FactoryGirl.create(:published_document) }
  let(:user) { FactoryGirl.create(:user) }


  describe "root path" do
    it "contains info about published documents" do
      published_document
      visit root_url
      page.should have_content 'Published documents'
      page.should have_content published_document.title
    end
  end

  describe "Login page" do
    it "contains neccessary fields to login" do
      visit new_user_session_path
      page.should have_css('.email')
      page.should have_css('.password')
    end
  end

  describe "Sign up page" do
    it "contains neccessary fields to sign up" do
      visit new_user_registration_path
      page.should have_css('#user_name')
      page.should have_css('#user_email')
      page.should have_css('#user_password')
      page.should have_css('#user_password_confirmation')
    end
  end

  describe "Document page" do
    it "contains info about current document" do
     # published_document
      visit document_path published_document
      page.should have_content published_document.title
      page.should have_content published_document.user.name
      page.should have_content published_document.state
    end
  end

  describe "User" do

    it "tries to sign in with valid credentials " do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: '12345678'
      click_button 'Sign in'
      page.should have_content 'Signed in successfully.'
    end

    it "tries to sign in with invalid credentials" do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password+'qwertyuio'
      click_button 'Sign in'
      page.should have_content 'Invalid email or password.'
    end

    it 'tries to sign up with valid credentials' do
      visit new_user_registration_path
      fill_in 'user[email]', with: "user@demo.app"
      fill_in 'user[name]', with: 'user'
      fill_in 'user[password]', with: 'user.password'
      fill_in 'user[password_confirmation]', with: 'user.password'
      click_button 'Sign up'
      page.should have_content 'Welcome! You have signed up successfully.'
    end

  end


end
