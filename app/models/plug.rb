class Plug < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, presence: true
  validates :state, inclusion: { in: %w(on off) }
end
