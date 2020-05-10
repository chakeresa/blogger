FactoryBot.define do
  factory :comment do
    author_name { Faker::Name.name }
    body { Faker::Movies::HarryPotter.quote }
    article { nil }
  end
end
