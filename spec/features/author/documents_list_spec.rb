require 'spec_helper'

describe 'Author', js: true do
  let(:author) { FactoryGirl.create(:author) }
  let(:documents) { 2.times.map { FactoryGirl.create(:document) }  }
  let(:published_document) {FactoryGirl.create(:published_document)}
  let(:pending_document) {FactoryGirl.create(:document_pending_publication)}
  let(:sign_in) {
    author.documents = documents

    visit new_user_session_path
    fill_in 'user[email]', with: author.email
    fill_in 'user[password]', with: '12345678'
    click_button 'Sign in'
    find('.nav').should have_link('Author')
    author.documents = documents
    author.documents << published_document
    author.documents << pending_document
    visit author_documents_path
  }

  it 'goes to In progress' do
    sign_in
    documents.each do |document|
      find('tr', text: document.title).should have_content document.title, document.description.slice(0..100)
      find('tr', text: document.title).should have_link('Show')
      find('tr', text: document.title).should have_link('Edit')
      find('tr', text: document.title).should have_link('Destroy')
      find('tr', text: document.title).should have_link('Send for review')
    end
  end

  it 'goes to Published' do
    sign_in
    click_link 'Published'
    page.should have_content published_document.title, published_document.description.slice(0..100), published_document.state
    find('tr', text: published_document.title).should have_link 'Show'
  end

  it 'goes to Pending' do
    sign_in
    click_link 'Pending'
    page.should have_content pending_document.title, pending_document.description.slice(0..100), pending_document.state
    find('tr', text: pending_document.title).should have_link 'Show'
  end

  it 'goes to specific show document in progress page' do
    sign_in
    click_link 'In progress'
    random_document = documents.shuffle.first

    visit author_document_path(random_document.id)
    page.should have_content random_document.title, random_document.description, random_document.state, random_document.attachments.map {|attachment| attachment.file.name}
  end

  it 'submits specific document for review' do
    sign_in
    random_document = documents.shuffle.first

    find('tr',text: random_document.title).click_link 'Send for review'
    page.should have_content 'Document was successfully sent for review'
  end

  it 'deletes specific document in progress' do
    sign_in
    click_link 'In progress'
    random_document = documents.shuffle.first
    find('tr', text: random_document.title).click_link 'Destroy'
    page.driver.browser.switch_to.alert.accept
    page.should have_content 'Document was successfully destroyed'
  end

  it 'creates new document with invalid credentials' do
    sign_in
    click_link 'In progress'
    click_link 'New Document'
    fill_in 'document[title]', with: 'Qwerty'
    fill_in 'document[description]', with: 'qweqweqwertyqwerty@demo.app'

    click_button 'Create Document'
    page.should have_content 'Please review the problems below', 'should have any attachments'
  end

  it 'edits existing document with valid credentials' do
    random_document = documents.shuffle.first
    sign_in
    click_link 'In progress'
    find('tr', text: random_document.title).click_link 'Edit'
    fill_in 'document[title]', with: 'Qwerty'
    fill_in 'document[description]', with: 'qweqweqwertyqwerty@demo.app'
    click_button 'Update'
    page.should have_content 'Document was successfully updated.'
  end

  it 'edits existing document with invalid credentials' do
    random_document = documents.shuffle.first
    sign_in
    click_link 'In progress'
    find('tr', text: random_document.title).click_link 'Edit'
    fill_in 'document[title]', with: 'Small'
    fill_in 'document[description]', with: 'Small too'
    click_button 'Update'
    page.should have_content 'Please review the problems below'
  end




end
