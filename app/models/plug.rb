class Plug < ActiveRecord::Base
  belongs_to          :user
  before_validation   :before_validation_plug
  
  validates :user_id, presence: true
  validates :name, presence: true
  validates :state, inclusion: { in: %w(on off) }
  
  def get_state
    # call integration function to get plug's state
    state = get_external_state(self.feed_id)
    
    if !state[:error].nil?
      # yeah... do something about that.... later? Need figure this out
      return state[:error]
    elsif !state[:state].nil?
      # got the latest state, return that
      return state[:state]
    else
      # somehow you don't have a state or an error?
      return "Can't find adafruit integration"
    end
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

    # Either returns :state with last value or :error
    def get_external_state(feed_id)
        aio = Adafruit::IO::Client.new :key => '792e5b98480a408ca686a334b05bc68e'
        feed = aio.feeds.retrieve(feed_id)
        
        if(defined? feed.error) # if error method is defined, you have one
            return error_codes(feed.error)
        elsif(defined? feed.id) # feed.id is defined, you're all good, return last value
            return :state => feed.last_value
        else # there was a problem, adafruit didn't catch it, write your own
            return error_codes("generic")
        end
    end
    
    def error_codes(error)
        puts case error
        when "not found - API documentation can be found at https://io.adafruit.com/api/docs"
            return :error => "Feed not found"
        when "Invalid AIO Key"
            return :error => "Invalid AIO Key"
        else
            return :error => "Generic error reading from Adafruit"
        end
    end

end
