# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.create!(
  name: ENV["ADMIN_USER_NAME"],
  email: ENV["ADMIN_USER_EMAIL"],
  password: ENV["ADMIN_USER_PASSWORD"],
  role: "admin"
) unless User.exists?(email: ENV["ADMIN_USER_NAME"])

Department.create!(name: "Human Resources") unless Department.exists?(name: "Human Resources")
Department.create!(name: "Finance") unless Department.exists?(name: "Finance")
Department.create!(name: "Engineering") unless Department.exists?(name: "Engineering")
Department.create!(name: "Marketing") unless Department.exists?(name: "Marketing")
Department.create!(name: "Sales") unless Department.exists?(name: "Sales")
