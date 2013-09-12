# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:email) {|n| "person-#{n}@demo.app" }
  sequence(:name) {|n| "Person #{n}"}

  factory :user do
    email
    name
    password '12345678'
    factory :admin do
      after(:create) {|user| user.add_user_role('admin')}
    end
    factory :author do
      after(:create) {|user| user.add_user_role('author')}
    end
    factory :reviewer do
      after(:create) {|user| user.add_user_role('reviewer')}
    end



  end


end
