FactoryGirl.define do
  factory :article do
    name "An article"
    body "Some text"
    published_at Time.now
  end
end
