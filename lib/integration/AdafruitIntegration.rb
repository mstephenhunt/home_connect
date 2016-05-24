module AdafruitIntegration
    # Use this as the interface to whatever service is being used
    require 'adafruit/io'
    class AdafruitIntegration
        
    end
    
    # Parses error strings
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
    

end

