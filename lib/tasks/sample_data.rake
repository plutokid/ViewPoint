namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_locations
    make_user_responses
    make_pending_locations
  end
end


def make_users
  unless User.any?
    admin = User.create!(name:     "ADMIN SHUM",
                         username:    "mshum",
                         password: "foobar",
                         password_confirmation: "foobar",
                         gps_location: "42.35689883623664, -71.09561786055565", #Baker House
                         admin: true)
    19.times do |n|
      name  = Faker::Name.name
      username = "user#{n}"
      password  = "password"
      User.create!(name:     name,
                   username:    username,
                   password: password,
                   password_confirmation: password,
                   gps_location: "42.35689883623664, -71.09561786055565")
    end
  end
end

def make_locations
  unless Location.any?
    1.upto(16).each do |n|
      title  = Faker::Address.city
      if title.length > 20
        title = title[1, 20]
      end
      description = Faker::Lorem.paragraph
      gps_location  = rand_in_range(42.327839208851266, 42.3958261564156).to_s + ", " + rand_in_range(-71.12943649291992, -71.02540969848633).to_s
      difficulty = Random.rand(10) + 1
      hints = Faker::Lorem.paragraph
      suggestions = Faker::Lorem.paragraph
      Location.create!(title: title,
                   description: description,
                   gps_location: gps_location,
                   difficulty: difficulty,
                   hints: hints,
                   suggestions: suggestions,
                   image_file_name: "img#{n}.jpg",
                   user_id: n)
    end
  end

end

def make_user_responses
  unless UserResponse.any?
    1.upto(6).each do |u|
      UserResponse.create!(user_id: u, location_id: 2, rating: Random.rand(10) + 1, image_file_name: "img2-#{u}.jpg", comments: Faker::Lorem.paragraph)
    end

    1.upto(4).each do |u|
      UserResponse.create!(user_id: u, location_id: 3, rating: Random.rand(10) + 1, image_file_name: "img3-#{u}.jpg", comments: Faker::Lorem.paragraph)
    end

    1.upto(4).each do |u|
      UserResponse.create!(user_id: u, location_id: 4, rating: Random.rand(10) + 1, image_file_name: "img4-#{u}.jpg", comments: Faker::Lorem.paragraph)
    end

    1.upto(2).each do |u|
      UserResponse.create!(user_id: u, location_id: 5, rating: Random.rand(10) + 1, image_file_name: "img5-#{u}.jpg", comments: Faker::Lorem.paragraph)
    end

  end
end

def make_pending_locations
  unless PendingLocation.any?
    6.upto(16).each do |l|
      if Random.rand(2) == 0
        PendingLocation.create!(user_id: 1, location_id: l)
      end
    end
  end
end

def rand_in_range(min, max)
  return min + (max - min) * Random.rand()
end