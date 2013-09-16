# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:title) { |n| "Title ##{n}"}
  sequence(:description) {|n| "Sample text #{n}"*25}

  factory :document do
    title
    description
    attachments {
      5.times.map {FactoryGirl.create(:attachment)}
    }
    user_id { FactoryGirl.create(:user).id }
  end

  factory :published_document, class: Document do
    title
    description
    attachments {
      5.times.map {FactoryGirl.create(:attachment)}
    }
    state 'published'
    user_id { FactoryGirl.create(:user).id }
  end

  factory :document_in_rework, class: Document do
    title
    description
    attachments {
      5.times.map {FactoryGirl.create(:attachment)}
    }
    user_id { FactoryGirl.create(:user).id }
    state 'in rework'
  end

  factory :document_pending_review, class: Document do
    title
    description
    attachments {
      5.times.map {FactoryGirl.create(:attachment)}
    }
    user_id { FactoryGirl.create(:user).id }
    state 'pending review'
  end

  factory :document_pending_publication, class: Document do
    title
    description
    attachments {
      5.times.map {FactoryGirl.create(:attachment)}
    }
    user_id { FactoryGirl.create(:user).id }
    state 'pending publication'
  end

end
