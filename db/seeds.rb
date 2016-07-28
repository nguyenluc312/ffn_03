User.create name: "Do Gia Dat",
  email: "dogiadat@gmail.com",
  password: "dogiadat",
  password_confirmation: "dogiadat",
  role: 1

User.create name: "Admin",
  email: "admin@framgia.com",
  password: "iamadmin",
  password_confirmation: "iamadmin",
  role: 1,
  confirmed_at: Time.now

(1..10).each do |n|
  User.create name: "User #{n}",
    email: "user#{n}@gmail.com",
    password: "password",
    password_confirmation: "password",
    confirmed_at: Time.now
end
