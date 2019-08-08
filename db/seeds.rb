User.create!(name:  "Duclh",
             email: "admin@gmail.com",
             password:              "12345678",
             password_confirmation: "12345678",
             admin: true,
             activated: true,
             role: 0)
20.times do |n|
  name  = Faker::Name.name
  email = "company-#{n+1}@gmail.com"
  password = "12345678"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               role: 1)
end
Task.create!(title: "Thiet ke giao dien",
             member_id: 2,
             content: "Thiet ke giao dien trang web mua sam don gian",
             salary: "200$",
             skill: "html, css, javascript",
             start_date: DateTime.new(2019,9,1),
             end_date: DateTime.new(2019,9,4))
Task.create!(title: "Thiet ke database",
             member_id: 2,
             content: "Thiet ke databse web mua sam",
             salary: "200$",
             skill: "sql, sqlite",
             start_date: DateTime.new(2019,9,4),
             end_date: DateTime.new(2019,10,10))
Task.create!(title: "Ban Hang",
             member_id: 2,
             content: "ban hang trong dip noel",
             salary: "50$",
             skill: "ua nhin, an noi tot, hoat bat",
             start_date: DateTime.new(2019,11,4),
             end_date: DateTime.new(2019,12,4))
10.times do |n|
  name  = Faker::Name.name
  email = "no_company-#{n+1}@gmail.com"
  password = "12345678"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: false ,
               role: 1)
end
100.times do |n|
  name  = Faker::Name.name
  email = "student-#{n+1}@gmail.com"
  password = "12345678"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               role: 2)
end
member = User.where(role: 2).limit(10)
50.times do
  content = Faker::Lorem.sentence(5)
  member.each { |member| member.reports.create!(content: content) }
end
# Add relationships
members = User.where(role: 2).all
member1  = members.first
following = members[2..50]
followers = members[3..40]
following.each { |followed| member1.follow(followed) }
followers.each { |follower| follower.follow(member1) }
