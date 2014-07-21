Fabricator :project do
  title { Faker::Lorem.words.join(" ") }
  starts_at { Time.now + 1.week }
  ends_at { Time.now + 1.year }
  creator { Fabricate :user }
end