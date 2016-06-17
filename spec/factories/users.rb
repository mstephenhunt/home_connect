# spec/factories/users.rb
require 'faker'

FactoryGirl.define do
    factory :user do |u|
        u.name                      { Faker::Name.name }
        u.email                     { Faker::Internet.email }
        u.password                  { Faker::Internet.password 6, 20 }
        u.password_confirmation     { "#{password}" }
    end
end