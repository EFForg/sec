FactoryGirl.define do
  factory :admin_user do
    email "admin@example.com"
    password "rspec123"
    password_confirmation "rspec123"
  end
end
