# app/models/room.rb
class Room < ActiveRecord::Base
    belongs_to  :user
    has_many    :plugs
    
    validates   :name,      presence: true
    validates   :user_id,   presence: true
    validates   :user,      presence: true
end
