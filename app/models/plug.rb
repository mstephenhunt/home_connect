class Plug < ActiveRecord::Base
  belongs_to          :user
  before_validation   :before_validation_plug
  
  validates :user_id, presence: true
  validates :state, inclusion: { in: %w(on off) }
  
  private
    def before_validation_plug
      clean_state
    end
  
    def clean_state
      # if state is undefined, default to "off"
      if self.state.nil?
        self.state = "off"
      end
      
      # whatever state was defined, downcase it
      self.state = self.state.downcase
    end

end
