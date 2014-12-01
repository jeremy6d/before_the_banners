Fabricator(:user) do
  first_name            { Faker::Name.first_name  }
  last_name             { Faker::Name.last_name   }
  email                 { Faker::Internet.email   }
  password              { PASSWORD                }
  password_confirmation { PASSWORD                }
  company_attributes do
    { title: "The #{Faker::Lorem.word} Company" }
  end
end