Fabricator :update do
  body { Faker::Lorem.paragraph }
  workspace { Workspace.all.to_a.sample || Fabricate(:workspace) }
  author { Fabricate :user }
end