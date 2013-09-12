require 'spec_helper'

describe Document do
  let(:document)  {FactoryGirl.create(:document) }

  it 'should be valid' do
    document.should be_valid
  end

  it 'should have state by default' do
    document.state.should_not be_nil
  end

  it 'should have ability to change state from "in creation" to "pending review"' do
    document.send_for_review.should == true
  end

  it 'should have ability to change state from "pending review" to "in rework"' do
    document.state = 'pending review'
    document.send_for_rework.should == true

  end

  it 'should have ability to change state from "pending review" to "pending publication"' do
    document.state = 'pending review'
    document.send_for_publication.should == true
  end

  it 'should have ability to change state from "pending publication" to "published"' do
    document.state = 'pending publication'
    document.publish.should == true
  end


  it 'should return count of documents by state' do
    10.times {FactoryGirl.create(:document)}
    7.times {FactoryGirl.create(:document_in_rework)}
    2.times {FactoryGirl.create(:document_pending_review)}
    2.times {FactoryGirl.create(:document_pending_publication)}
    FactoryGirl.create(:published_document)
    #10 documents in creation
    #2 documents pending review
    #7 documents in rework
    #2 documents pending publication
    #1 published document
    @expected_result = {published: 1, pending_publication: 2, pending_review: 2, in_rework: 7, in_creation: 10}
    Document.counted_by_state.should == @expected_result
  end


end
