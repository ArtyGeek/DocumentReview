# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attachment do
    file File.new(Rails.root.join('spec','factories','sample_doc.pdf'))
  end
end
