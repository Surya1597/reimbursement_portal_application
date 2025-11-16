# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Department.find_or_create_by(name: "Human Resources") unless Department.exists?(name: "Human Resources")
Department.find_or_create_by(name: "Finance") unless Department.exists?(name: "Finance")
Department.find_or_create_by(name: "Engineering") unless Department.exists?(name: "Engineering")
Department.find_or_create_by(name: "Marketing") unless Department.exists?(name: "Marketing")
Department.find_or_create_by(name: "Sales") unless Department.exists?(name: "Sales")
