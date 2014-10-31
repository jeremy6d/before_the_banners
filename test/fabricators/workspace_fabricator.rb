Fabricator(:workspace) do
  title { Faker::Lorem.words.join(" ") }
  description { Faker::Lorem.paragraph }
end