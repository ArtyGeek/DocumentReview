require 'spec_helper'
require 'factory_girl_rails'


describe User do

  let(:user) {FactoryGirl.create(:user)}

  it {should have_many(:documents)}
  it {should have_many(:comments)}

  it 'should be valid' do
    user.should be_valid
  end

  it 'should have role "default" after creation' do
     user.roles.first.name.should == 'default'
  end

  it 'should have ability for role to be changed' do
    ENV['ROLES'].split(',').each do |role|
      user.add_user_role role
      user.roles.first.name.should == role
    end

  end
end
