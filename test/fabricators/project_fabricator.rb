Fabricator :project do
  title { Faker::Lorem.words.join(" ") }
  starts_at { Time.now + 1.week }
  ends_at { Time.now + 1.year }
  creator { Fabricate :user }
  value { 10000000 }
  owner_title { Faker::Company.name }
  architect_title { Faker::Company.name }
  builder_title { Faker::Company.name }
end