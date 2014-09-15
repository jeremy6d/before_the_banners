jeremy =  User.create first_name: "Jeremy", 
                      last_name: "Weiland", 
                      email: "jeremy@6thdensity.com", 
                      password: "password123",
                      password_confirmation: "password123",
                      company_attributes: { 
                        title: "6th Density LLC" 
                      }

jeff =    User.create first_name: "Jeff", 
                      last_name: "Wraley", 
                      email: "jeff@beforethebanners.com", 
                      password: "password123",
                      password_confirmation: "password123",
                      company_attributes: { 
                        title: "Before the Banners LLC" 
                      }

proj_1 = Project.create title: "804RVA Remodel",
                        address: "1000 Semmes Ave, Richmond VA 23225"
                        type: "Facility",
                        value: 3000000,
                        owner_title: "804RVA",
                        architect_title: "Baskervill",
                        builder_title: "Capstone",
                        description: "A new community space for entrepreneurs, remote workers, and activists!",
                        starts_at: Date.parse("2014-01-01"),
                        ends_at: Date.parse("2014-12-31"),
                        creator: jeremy

proj_2 = Project.create title: "YMCA Project",
                        address: "1000 Byrd Ave, Richmond VA 23225"
                        type: "Gym",
                        value: 3000000,
                        owner_title: "Richmond YMCA",
                        architect_title: "Baskervill",
                        builder_title: "Capstone",
                        description: "A totally new gym for Richmond",
                        starts_at: Date.parse("2014-03-01"),
                        ends_at: Date.parse("2015-03-31"),
                        creator: jeff

proj_1.updates.create title: "Started the planning stages!",
                      body: "We have begun working with the architect and the city planner to make this work!  The investors are excited.",
                      author: jeremy,
                      attachment: File.open(Rails.root, "test", "fixtures", "planning.jpg")

proj_2.updates.create title: "Meeting with the board",
                      body: "We had a great meeting with the board of the Richmond YMCA and it went great!",
                      author: jeff,
                      attachment: File.open(Rails.root, "test", "fixtures", "ymca_leaders.jpg")
  
