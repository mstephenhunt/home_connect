class Plug < ActiveRecord::Base
  belongs_to          :user
  before_validation   :before_validation_plug
  
  validates :user, presence: true
  validates :user_id, presence: true
  validates :name, presence: true
  validates :feed_id, presence: true
  validates :state, inclusion: { in: %w(on off) }
  
  def get_state
    # call integration class to get plug's state
    state = PlugExtIntegration.get_state(self.feed_id)
    
    if !state[:error].nil?
      return state[:error]
    elsif !state[:state].nil?
      return state[:state]
    else
        return "Error finding state"
    end
  end
  
  
  def flip_plug
    # go out to adafruit to get the feed. Obviously change this later...
    state = PlugExtIntegration.get_state(self.feed_id)
    
    # if error, just exit
    if !state[:error].nil?
      return
    end
    
    # whatever the state is, flip it
    state[:state] = flip_state(state[:state])
    
    # write out that state change to adafruit
    PlugExtIntegration.set_state(self.feed_id, state[:state])
  end
  
  
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
    
    
    def flip_state(state)
      if state == "ON"
        return "OFF"
      elsif state == "OFF"
        return "ON"
      else
        return "OFF"
      end
    end
end
