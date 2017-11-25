FactoryBot.define do
  factory :expense do
    vendor { Faker::Company.name }
    amount { Faker::Number.number(3) }
    date { Faker::Time.between(DateTime.now - 100, DateTime.now) }
  end
end
