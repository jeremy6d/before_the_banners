Fabricator :update do
  body { Faker::Lorem.paragraph }
  workspace
  author { Fabricate :user }
end