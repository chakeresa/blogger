FactoryBot.define do
  factory :article do
    title { Faker::Space.agency }
    body {
      Faker::Hipster.paragraph(
        sentence_count: 2,
        supplemental: true,
        random_sentences_to_add: 4
      )
    }
  end
end
