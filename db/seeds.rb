# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



# rails db:seed で実行

# サンプルadminアカウントの作成
# find_or_create_by ですでに同じメールアドレスの存在を確認 存在すれば作らない。
# do |admin| で存在しなければ他の属性も追加で新規作成する

admin = Admin.find_or_create_by(email: "a@a") do |admin|
  admin.password = "123456"
  puts "email = a@a"
  puts "password = 123456"
end
