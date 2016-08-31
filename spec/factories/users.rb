# spec/factories/users.rb
require 'faker'

FactoryGirl.define do
    factory :user do
        name                      { Faker::Name.name }
        email                     { Faker::Internet.email }
        password                  { Faker::Internet.password 6, 20 }
        password_confirmation     { "#{password}" }
  
        factory :user_with_plug do
            after(:create) do |user|
                room = create(:room, user: user)
                create(:plug, user: user, room: room)
            end
        end
        
        factory :user_with_room do
            after(:create) do |user|
                create(:room, user: user)
            end
        end
    end
end