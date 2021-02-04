# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# メインユーザーを作成
User.create!(name: 'Foo Bar',
             email: 'foobar@example.com',
             password: 'password',
             password_confirmation: 'password',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

# ゲストユーザーの作成
User.create!(name: 'Guest User',
             email: 'guest@example.com',
             password: 'password',
             password_confirmation: 'password',
             admin: false,
             activated: true,
             activated_at: Time.zone.now)

# 追加のユーザーを作成
10.times do |n|
  name = Faker::Name.name
  email = "monogeuser-#{n}@example.com"
  password = 'password'
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               admin: false,
               activated: true,
               activated_at: Time.zone.now)
end

# ユーザーの一部を対象にマイクロポストを生成する
users = User.order(:created_at).take(6)
10.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.posts.create!(content: content) }
end

# ユーザーの一部を対象にリストを作成

# フォロー関係を作成
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
