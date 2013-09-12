# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    content "Lorem ipsum !@#$%^^&(*)))+_}"
    user_id 1
    document_id 1
  end
end
