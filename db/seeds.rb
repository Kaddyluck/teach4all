# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts <<-LOG
\n========================================
Creating users...
LOG
user = User.new(
  email: 'defaultuser1@example.org',
  nickname: 'defaultuser1',
  first_name: 'Default',
  last_name: 'Userone',
  password: 'password',
  password_confirmation: 'password'
)
user.skip_confirmation!
user.save!
puts "  #{user.email}"

user = User.new(
  email: 'adminuser1@example.org',
  nickname: 'adminuser1',
  first_name: 'Admin',
  last_name: 'Userone',
  password: 'password',
  password_confirmation: 'password'
)
user.skip_confirmation!
user.save!
puts "  #{user.email}"

50.times do |number|
  user = User.new(
    email: Faker::Internet.unique.safe_email,
    nickname: Faker::Internet.unique.user_name,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    password: 'password',
    password_confirmation: 'password'
  )
  user.skip_confirmation!
  user.save!
  puts "  #{user.email}"
end

puts <<-LOG
Created
========================================
LOG

puts <<-LOG
\n========================================
Creating messages...
LOG

  User.all.each do |user|
    print "\n  User @#{user.nickname} is sending messages: "
    30.times do
      receivers = User.all.sample(rand(1..2))
      MessageSending.new(
        sender_id: user.id,
        receiver_ids: receivers.pluck(:id),
        body: Faker::Lorem.sentences(rand(1..10)).join(' ')
      ).perform
      print '.'
    end
  end

puts <<-LOG
\nCreated
========================================
LOG

25.times {Organization.create(name:Faker::Company.unique.name)}
