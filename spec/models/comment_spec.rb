require 'spec_helper'

describe Comment do
  let(:comment) {FactoryGirl.create(:comment)}

  it 'should be valid' do
    comment.should be_valid
  end
end
