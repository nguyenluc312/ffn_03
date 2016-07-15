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

Country.create code: "VN"

10.times do |n|
  league = League.create(country_id: 1, name: "League #{n+1}")
  10.times do |m|
    league.league_seasons.create(year: m+1)
  end
end

20.times do |n|
  Team.create(name: "Team #{n+1}", introduction: "intro", country_id: 1)
end
