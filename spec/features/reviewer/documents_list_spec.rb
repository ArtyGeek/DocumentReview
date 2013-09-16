require 'spec_helper'

describe 'Reviewer', js: true do
  let(:reviewer) { FactoryGirl.create(:reviewer) }
  let(:pending_review_documents) { 2.times.map { FactoryGirl.create(:document_pending_review) }  }
  let(:document_in_rework) { FactoryGirl.create(:document_in_rework) }
  let(:pending_publication_document) { FactoryGirl.create(:document_pending_publication) }
  let(:sign_in) {
    pending_publication_document
    document_in_rework
    pending_review_documents
    visit new_user_session_path
    fill_in 'user[email]', with: reviewer.email
    fill_in 'user[password]', with: '12345678'
    click_button 'Sign in'
    find('.nav').should have_link('Reviewer')
    visit reviewer_documents_path
  }

  it 'goes to In rework' do
    sign_in
    click_link 'In rework'
    page.should have_content document_in_rework.title, document_in_rework.description.slice(0..100), document_in_rework.state
    find('tr', text: document_in_rework.title).should have_link 'Show'
  end

  it 'goes to Pending publication' do
    sign_in
    click_link 'Pending publication'
    page.should have_content pending_publication_document.title, pending_publication_document.description.slice(0..100), pending_publication_document.state
    find('tr', text: pending_publication_document.title).should have_link 'Show'
  end

  it 'goes to Pending' do
    sign_in
    click_link 'Pending'
    pending_review_documents.each do |pending_document|
      page.should have_content pending_document.title, pending_document.description.slice(0..100), pending_document.state
      find('tr', text: pending_document.title).should have_link 'Show'
    end
  end

  it 'goes to specific show pending review document  page' do
    sign_in
    click_link 'Pending'
    random_document = pending_review_documents.shuffle.first
    visit reviewer_document_path(random_document.id)
    page.should have_content random_document.title, random_document.description, random_document.state, random_document.attachments.map {|attachment| attachment.file.name}
    page.should have_link 'Send for publication'
    page.should have_button 'Send back for rework'
  end

  it 'submits specific document for publication' do
    sign_in
    random_document = pending_review_documents.shuffle.first
    visit reviewer_document_path(random_document.id)
    click_link 'Send for publication'
    page.should have_content 'Document was successfully reviewed and sent for publication'
  end

  it 'sends specific document back for rework with valid comment credentials' do
    sign_in
    click_link 'Pending'
    random_document = pending_review_documents.shuffle.first
    visit reviewer_document_path(random_document.id)
    fill_in ('document[comments_attributes]'+'[0]'+'[content]'), with: 'Sorry but u should edit this file'
    click_button 'Send back for rework'
    page.should have_content 'Document was successfully commented and sent for rework'
  end

  it 'sends specific document back for rework with invalid comment credentials' do
    sign_in
    click_link 'Pending'
    random_document = pending_review_documents.shuffle.first
    visit reviewer_document_path(random_document.id)
    click_button 'Send back for rework'
    page.should have_content 'Comment', "can't be blank"
  end

end
