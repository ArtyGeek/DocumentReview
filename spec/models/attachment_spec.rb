require 'spec_helper'

describe Attachment do
  let(:attachment) {FactoryGirl.create(:attachment)}

  it 'should be valid' do
    attachment.should be_valid
  end
end
