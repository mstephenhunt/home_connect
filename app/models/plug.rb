class Plug < ActiveRecord::Base
  belongs_to          :user,  dependent: :destroy
  belongs_to          :room
  
  before_validation   :before_validation_plug
  
  validates :name,    presence: true
  validates :feed_id, presence: true               
  validates :state,   presence: true, inclusion: { in: %w(ON OFF ERR) }
  validates :user_id, presence: true
  validates :user,    presence: true
  validates :room_id, presence: true
  validates :room,    presence: true

  # returns a hash with params [:error] and [:state]
  def get_state
    if self.feed_id.nil?
      return { state: nil, error: "Error: no feed provided" }
    end
    
    # call integration class to get plug's state
    state = PlugExtIntegration.get_state(self.feed_id)
    
    # if somehow you didn't get a state or an error, mark there being a problem
    if state[:error].nil? && state[:state].nil?
      return { state: nil, error: "Error finding state" }
    end
    
    return state
  end
  
  
  def flip_plug
    # whatever the state is, flip it
    flipped_state = flip_state(self.state)
    
    # write out that state change to adafruit
    write_out = PlugExtIntegration.set_state(self.feed_id, flipped_state)
    
    # if an error has been returned, return the error hash
    if (defined? write_out[:error])
      return write_out
    end
    
    # Save the state change on this plug, save it locally
    self.state = flipped_state
    self.save
  end
  
  
  private

    def before_validation_plug
      # if the plug's state isn't valid, attempt to go out and find it
      if self.state != "ON" || self.state != "OFF" || self.state != "ERR"
        ret_state = self.get_state
        
        # if you got a state back, set it on the plug. Otherwise set ERR
        if(!ret_state[:state].nil?)
          self.state = ret_state[:state]
        else
          self.state = "ERR"
        end
      end
      
      # If plug state is undefined, default to ERR
      if self.state.nil?
        self.state == "ERR"
      end
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
