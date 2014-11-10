def upload! filename
  File.open(File.join(Rails.root, "db", "media", filename), "r")
  #   "image/#{filename.split('.').last.gsub(/jpg/i, 'jpeg')}").tap do |f|
  #   binding.pry 
  # end
end

START_OF_TIME = Time.now - 3.months

def sequential_mock_time!
  @time = if @time.nil? 
    START_OF_TIME
  else
    @time + rand(1..72).hours
  end
end

puts "Do you want to proceed, losing all existing data for the \"#{Rails.env}\" environment? (yes/no)"
unless /y/i.match STDIN.gets.chomp
  puts("Exiting.")
  exit
end

Mongoid.default_session.collections.each &:drop

puts "creating user Jeremy"
jeremy =  User.create!  first_name: "Jeremy", 
                        last_name: "Weiland", 
                        email: "jeremy@6thdensity.com", 
                        password: "password123",
                        password_confirmation: "password123",
                        company_attributes: { 
                          title: "6th Density LLC" 
                        },
                        created_at: sequential_mock_time!

puts "creating user Jeff"
jeff =    User.create!  first_name: "Jeff", 
                        last_name: "Wraley", 
                        email: "jeff@beforethebanners.com", 
                        password: "leanasfuck",
                        password_confirmation: "leanasfuck",
                        company_attributes: { 
                          title: "Before the Banners LLC" 
                        },
                        created_at: sequential_mock_time!

puts "creating project Parkside"
parkside = Project.create! "title"=>"Parkside Town Commons",
                           "type"=>"Mixed Use Development",
                           "value"=>115000000,
                           "description"=> "Parkside Towne Commons is a mixed use development offering sleek condos, a walkable promenade with several restaurant options, an upscale bowling alley and lounge, and shopping galore. Among the stores that will be part of the development are Golf Galaxy, Field & Stream, and Whole Foods.",
                           "starts_at" => (Time.now + 1.month),
                           "ends_at" => (Time.now + 1.year),
                           "owner_title"=>"Kite Realty",
                           "architect_title"=>"OmniPlan Architects",
                           "builder_title"=>"VCC, Williams Company",
                           creator: jeff,
                           logo: upload!("parkside_logo.jpg"),
                           created_at: sequential_mock_time!

puts "creating project Gilmer hall"
gilmer_hall = Project.create! "architect_title"=>"TSOI/Kobus & Associates",
                              "builder_title"=>"McCarthy-Donley's",
                              creator: jeff,
                              "description" => "The Gilmer Hall & Chemistry Building renovation project includes upgrades and improvements to 430,000 square feet of two of UVA's campus landmarks. All plumbing, HVAC and electrical systems will be replaced with energy efficient systems and the interior spaces will be upgraded to accommodate modern research and teaching practices. The project will be phased in order to maintain partial use of the buildings as they are being upgraded.",
                              "starts_at" => (Time.now + 1.month),
                              "ends_at" => (Time.now + 1.year),
                              logo: upload!("gilmer_hall_logo.jpg"),
                              "owner_title"=>"The University of Virginia",
                              "title"=>"UVA Gilmer Hall & Chemistry Building Renovation",
                              "type"=>"Higher Education, Renovation or Expansion",
                              "value"=>110000000,
                              created_at: sequential_mock_time!

puts "creating project Stone Brewing"
stone_brewing = Project.create! "architect_title"=>"Timmons Group",
                                "builder_title"=>"Hourigan Construction",
                                creator: jeff,
                                "description"=>
                                 "Stone Brewing's east cost facility will be the focal point of the craft beer movement on the east coast for years to come. The facility will include be 200,000 SF of brewing and tasting space and will be located in the historic Fulton Neighborhood.",
                                "logo"=>upload!("stone_brewing_logo.png"),
                                "owner_title"=>"Stone Brewing Company",
                                "starts_at" => (Time.now + 1.month),
                                "ends_at" => (Time.now + 1.year),
                                "title"=>"Stone Brewing Company - East Coast Facility",
                                "type"=>"New Construction - Food and Beverage",
                                "value"=>23000000

puts "creating project VCU basketball practice facility"
vcu = Project.create! "architect_title"=>"VMDO Architects",
                      "builder_title"=>"Barton Malow Company",
                      creator: jeff,
                      "description"=>
                      "The VCU Basketball Practice facility will provide state of the art training facilities for the university's student athletes for years to come. The facility will house two full size practice courts, state of the art locker rooms, and advanced training facilities. The design also includes a hall of fame and space for team meetings.",
                      "starts_at" => (Time.now + 1.month),
                      "ends_at" => (Time.now + 1.year),
                      "logo"=>upload!("vcu_logo.png"),
                      "owner_title"=>"VCU Athletics",
                      "title"=>"VCU Basketball Practice Facility",
                      "type"=>"Higher Education - Sports",
                      "value"=>25000000



WORKSPACES = [
 { :title=>"Frank's Theater and Bowling Center", :description=>"http://www.franktheatres.com/CINEBOWLGRILLE.aspx", :project=>parkside },
 { :title=>"Excavation", :description=>"", :project=>vcu},
 { :title=>"Toby Keith's Bar and Grille", :description=>"Toby Keith's Bar and Grille", :project=>parkside},
 { :title=>"Foundations", :description=>"", :project=>vcu},
 { :title=>"Field & Stream", :description=>"A part of the Dicks Sporting Goods brand, Field and Stream offers products and supplies for avid or novice sportsman or sportswoman.", :project=>parkside},
 { :title=>"Sitework", :description=>"", :project=>vcu},
 { :title=>"Apartment Complex", :description=>"Multi-family housing with amenities like a swimming pool, exercise facility, and close proximity to all that Parkside Towne Commons has to offer.", :project=>parkside},
 { :title=>"Structural Steel", :description=>"", :project=>vcu},
 {
  :title=>"Sitework",
  :description=>"This workspace will show the impressive amount of work that went into getting the construction site prepped for the development's infrastructure and buildings.",
  :project=>parkside},
 { :title=>"Electrical, Mechanical, & Plumbing", :description=>"", :project=>vcu},
 { :title=>"Starbucks/Verizon", :description=>"Starbucks and Verizon will have one of the most prominent out lots at Parkside Towne Commons", :project=>parkside},
 { :title=>"Building Envelope", :description=>"", :project=>vcu},
 { :title=>"Landscaping & Paving", :description=>"Common spaces and thoroughfares throughout the development.", :project=>parkside},
 { :title=>"East Court", :description=>"", :project=>vcu, :attachment => upload!("Workspace East_Court.png")},
 { :title=>"West Court", :description=>"", :project=>vcu, :attachment => upload!("Workspace West_Court.png")},
 { :title=>"Training, Equipment, & Video", :description=>"", :project=>vcu, attachment: upload!("Workspace Training_Equip_Video.png")},
 { :title=>"Locker Rooms", :description=>"", :project=>vcu, attachment: upload!("Workspace Locker_Rooms.png")},
 { :title=>"Team Lounges", :description=>"", :project=>vcu, attachment: upload!("Workspace Team_Lounges.png")},
 { :title=>"Coaching & Administration", :description=>"", :project=>vcu, attachment: upload!("Workspace Coaching_Administration.png") },
 { :title=>"Offsite Roadwork", :description=>"There are several intersections nearby that need to be adjusted to handle the additional traffic flow anticipated as a result of our popular development.", :project=>parkside},
 { :title=>"Phase 1 - Target/Petco", :description=>"PetCo and Target are part of Phase 1 Construction", :project=>parkside},
 { :title=>"Phase 1 - Level 3 of Chemistry Building", :description=>"Create construction access to the basement mechanical room. Integrate make-up air handlers into existing systems. Renovate mechanical room and install new systems.", :project=>gilmer_hall},
 {
  :title=>"Phase 1 - Level 1 Gilmer Hall",
  :description=>
   "Active construction of west end of the Chemistry Building (all floors). Demolish interior partitions, remove flooring and select finishes, replace HVAC, plumbing, and electrical systems. Construct new office and lab spaces on all floors.",
  :project=>gilmer_hall},
 { :title=>"Bottling Line", :description=>"", :project=>stone_brewing},
 { :title=>"Fermentation Tanks", :description=>"", :project=>stone_brewing},
 { :title=>"Brewing Area", :description=>"", :project=>stone_brewing},
 { :title=>"Tasting Room", :description=>"", :project=>stone_brewing},
 { :title=>"Building Exterior", :description=>"", :project=>stone_brewing},
 { :title=>"Sitework and Landscaping", :description=>"", :project=>stone_brewing}].each { |attrs| 
  puts "creating workspace #{attrs[:title]}"
  Workspace.create!(attrs) 
}

 UPDATES = [
 {:workspace => Workspace.find_by(title: "Offsite Roadwork"), :body=>"Work at the intersection north of the development is complete!", :project => Project.find_by(title: "Parkside Town Commons"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("IMG_3522.JPG")},
 {:workspace => Workspace.find_by(title: "Offsite Roadwork"), :body=>"Work on Phase 1 (Target and PetCo) is wrapping up.", :project => Project.find_by(title: "Parkside Town Commons"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("IMG_3550.JPG")},
 {:workspace => Workspace.find_by(title: "Landscaping & Paving"), :body=>"Entrance from State Route 55.", :project => Project.find_by(title: "Parkside Town Commons"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("IMG_3609.JPG")},
 {:workspace => Workspace.find_by(title: "Apartment Complex"),
  :body=>"Wood Framing at the apartments near the west end of the project are progressing nicely.",
  :project => Project.find_by(title: "Parkside Town Commons"),
  :author => jeff, created_at: sequential_mock_time!,
  :attachment => upload!("IMG_4119.JPG")},
 {:workspace => Workspace.find_by(title: "Toby Keith's Bar and Grille"), :body=>"The exterior of the Toby Keith restaurant is nearly complete.", :project => Project.find_by(title: "Parkside Town Commons"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("IMG_4121.JPG")},
 {:workspace => Workspace.find_by(title: "Toby Keith's Bar and Grille"), :body=>"Masonry Crew working its way up the east facade of Toby Keith's", :project => Project.find_by(title: "Parkside Town Commons"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("IMG_4136.JPG")},
 {:workspace => Workspace.find_by(title: "Field & Stream"), :body=>"This building is going up fast! Parking lot is nearly ready for asphalt as well", :project => Project.find_by(title: "Parkside Town Commons"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("IMG_4162.JPG")},
 {:workspace => Workspace.find_by(title: "Frank's Theater and Bowling Center"),
  :body=>"Believe it or not, this will be a Franks Theater and Bowling center in a few months!",
  :project => Project.find_by(title: "Parkside Town Commons"),
  :author => jeff, created_at: sequential_mock_time!,
  :attachment => upload!("IMG_4208.JPG")},
 {:workspace => Workspace.find_by(title: "Field & Stream"), :body=>"Another look at the progress of the Field and Stream building.", :project => Project.find_by(title: "Parkside Town Commons"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("IMG_4248.JPG")},
 {:workspace => Workspace.find_by(title: "Frank's Theater and Bowling Center"), :body=>"Concrete slab on grade at Frank's", :project => Project.find_by(title: "Parkside Town Commons"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("IMG_4231.JPG")},
 {:workspace => Workspace.find_by(title: "Phase 1 - Target/Petco"), :body=>"Both Target and Petco are open for business!", :project => Project.find_by(title: "Parkside Town Commons"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("IMG_4097.JPG")},
 {:workspace => Workspace.find_by(title: "Starbucks/Verizon"),
  :body=>"Masonry walls being supported by \"deadmen\" until they get tied into the other walls and supports.",
  :project => Project.find_by(title: "Parkside Town Commons"),
  :author => jeff, created_at: sequential_mock_time!,
  :attachment => upload!("IMG_4180.JPG")},
 {:workspace => Workspace.find_by(title: "Toby Keith's Bar and Grille"), :body=>"Patio at Toby Keith's - nearly complete!", :project => Project.find_by(title: "Parkside Town Commons"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("IMG_4376.JPG")},
 {:workspace => Workspace.find_by(title: "Toby Keith's Bar and Grille"),
  :body=>"The future Toby Keith restaurant space...concrete slab will be poured as part of the fit-out process",
  :project => Project.find_by(title: "Parkside Town Commons"),
  :author => jeff, created_at: sequential_mock_time!,
  :attachment => upload!("IMG_4375.JPG")},
 {:workspace => Workspace.find_by(title: "Starbucks/Verizon"), :body=>"Starbucks' future location showing progress", :project => Project.find_by(title: "Parkside Town Commons"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("IMG_4453.JPG")},
 {:workspace => Workspace.find_by(title: "Frank's Theater and Bowling Center"),
  :body=>"More Concrete work at Frank's. You can see the slabs are sloped to accommodate the slope of the theaters.",
  :project => Project.find_by(title: "Parkside Town Commons"),
  :author => jeff, created_at: sequential_mock_time!,
  :attachment => upload!("IMG_4408.JPG")},
 {:workspace => Workspace.find_by(title: "Sitework"), :body=>"Holy retaining wall!", :project => Project.find_by(title: "Parkside Town Commons"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("IMG_4355.JPG")},
 {:workspace => Workspace.find_by(title: "Landscaping & Paving"), :body=>"Entrance pillars are ready to go.", :project => Project.find_by(title: "Parkside Town Commons"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("IMG_4294.JPG")},
 {:workspace => Workspace.find_by(title: "Field & Stream"), :body=>"You think people were excited for the grand opening?", :project => Project.find_by(title: "Parkside Town Commons"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("IMG_4483.JPG")},
 {:workspace => Workspace.find_by(title: "Frank's Theater and Bowling Center"), :body=>"Steel will soon start to be erected at Franks!", :project => Project.find_by(title: "Parkside Town Commons"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("IMG_4525.JPG")},
 {:workspace => Workspace.find_by(title: "Phase 1 - Level 3 of Chemistry Building"),
  :body=>"Demolition continues - really starting to make some progress!",
  :project => Project.find_by(title: "UVA Gilmer Hall & Chemistry Building Renovation"),
  :author => jeff, created_at: sequential_mock_time!,
  :attachment => upload!("interior_demolition2.jpg")},
 {:workspace => Workspace.find_by(title: "Phase 1 - Level 1 Gilmer Hall"),
  :body=>"Demolition starts today on the connector between Gilmer Hall and the Chemistry building.",
  :project => Project.find_by(title: "UVA Gilmer Hall & Chemistry Building Renovation"),
  :author => jeff, created_at: sequential_mock_time!,
  :attachment => upload!("interior_demolition_lab.jpg")},
 {:workspace => Workspace.find_by(title: "Phase 1 - Level 3 of Chemistry Building"),
  :body=>"This is a test update to see if the Workspaces display...",
  :project => Project.find_by(title: "UVA Gilmer Hall & Chemistry Building Renovation"),
  :author => jeff, created_at: sequential_mock_time!,
  :attachment => upload!("alert_map_for_app.png")},
 {:workspace => Workspace.find_by(title: "Fermentation Tanks"), :body=>"The first of 5 fermentation tanks is in place!", :project => Project.find_by(title: "Stone Brewing Company - East Coast Facility"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("brewerytank.jpg")},
 {:workspace => Workspace.find_by(title: "Sitework and Landscaping"),
  :body=>"The camera app works from an android device!",
  :project => Project.find_by(title: "Stone Brewing Company - East Coast Facility"),
  :author => jeff, created_at: sequential_mock_time!,
  :attachment => upload!("1414783604915742151886.jpg")},
 {:workspace => Workspace.find_by(title: "East Court"),
  :body=>"Check out the foundations going in at the north-east corner of the east court",
  :project => Project.find_by(title: "VCU Basketball Practice Facility"),
  :author => jeff, created_at: sequential_mock_time!,
  :attachment => upload!("IMG_5200.JPG")},
 {:workspace => Workspace.find_by(title: "West Court"),
  :body=>"Poured in place concrete walls are in place at the perimeter of the west court",
  :project => Project.find_by(title: "VCU Basketball Practice Facility"),
  :author => jeff, created_at: sequential_mock_time!,
  :attachment => upload!("IMG_5183.JPG")},
 {:workspace => Workspace.find_by(title: "Field & Stream"),
  :body=>"Busy lunch hour at field and stream! Frank's theater progress in the background.",
  :project => Project.find_by(title: "Parkside Town Commons"),
  :author => jeff, created_at: sequential_mock_time!,
  :attachment => upload!("1415120648049-471309751.jpg")},
 {:workspace => Workspace.find_by(title: "Starbucks/Verizon"), :body=>"Great progress on brickwork and roofing.", :project => Project.find_by(title: "Parkside Town Commons"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("1415120792674-867699887.jpg")},
 {:workspace => Workspace.find_by(title: "Frank's Theater and Bowling Center"),
  :body=>"Tilt up panels are complete. Flying steel roof trusses today!",
  :project => Project.find_by(title: "Parkside Town Commons"),
  :author => jeff, created_at: sequential_mock_time!,
  :attachment => upload!("14151208928201351143290.jpg")},
 {:workspace => Workspace.find_by(title: "Landscaping & Paving"), :body=>"Fresh concrete!", :project => Project.find_by(title: "Parkside Town Commons"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("1415120995563-238871187.jpg")},
 {:workspace => Workspace.find_by(title: "Landscaping & Paving"), :body=>"Colored concrete complete at building11", :project => Project.find_by(title: "Parkside Town Commons"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("14151210975122064249167.jpg")},
 {:workspace => Workspace.find_by(title: "Landscaping & Paving"),
  :body=>"An example of a patio between buildings...nice spot for lunch or a drink!",
  :project => Project.find_by(title: "Parkside Town Commons"),
  :author => jeff, created_at: sequential_mock_time!,
  :attachment => upload!("1415121141681-223168824.jpg")},
 {:workspace => Workspace.find_by(title: "Starbucks/Verizon"),
  :body=>"It's only a matter of time till you can grab your cup of coffee at this starbucks drive thru window",
  :project => Project.find_by(title: "Parkside Town Commons"),
  :author => jeff, created_at: sequential_mock_time!,
  :attachment => upload!("14151212740711744997759.jpg")},
 {:workspace => Workspace.find_by(title: "Frank's Theater and Bowling Center"),
  :body=>"Emergency exit at Frank's...the brown patch on the exterior wall will 've scraped off...it is a remnant of the pad where the concrete wall was poured prior to being tiled into place.",
  :project => Project.find_by(title: "Parkside Town Commons"),
  :author => jeff, created_at: sequential_mock_time!,
  :attachment => upload!("1415121398465-1587826307.jpg")},
 {:workspace => Workspace.find_by(title: "Frank's Theater and Bowling Center"),
  :body=>"This corner of Frank's will house the high end sports bar.",
  :project => Project.find_by(title: "Parkside Town Commons"),
  :author => jeff, created_at: sequential_mock_time!,
  :attachment => upload!("14151216046971004501973.jpg")},
 {:workspace => Workspace.find_by(title: "Apartment Complex"), :body=>"The exterior of the apartments is really coming along!", :project => Project.find_by(title: "Parkside Town Commons"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("1415121679473-678335425.jpg")},
 {:workspace => Workspace.find_by(title: "Frank's Theater and Bowling Center"),
  :body=>"Concrete curbs being poured at the east end of the site.",
  :project => Project.find_by(title: "Parkside Town Commons"),
  :author => jeff, created_at: sequential_mock_time!,
  :attachment => upload!("1415121781571-1357422298.jpg")},
 {:workspace => Workspace.find_by(title: "Apartment Complex"),
  :body=>"This building will be the first to open. The first leases could start before the first of the year.",
  :project => Project.find_by(title: "Parkside Town Commons"),
  :author => jeff, created_at: sequential_mock_time!,
  :attachment => upload!("1415121879064394338566.jpg")},
 {:workspace => Workspace.find_by(title: "Offsite Roadwork"), :body=>"Culvert extension work ongoing.", :project => Project.find_by(title: "Parkside Town Commons"), :author => jeff, created_at: sequential_mock_time!, :attachment => upload!("1415122286008-661570516.jpg")}
].each { |attrs| puts "creating update #{attrs[:body]}"; Update.create! attrs }
