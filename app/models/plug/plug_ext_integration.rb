require 'adafruit/io'

# Current implementation uses adafruit as mqtt broker
class Plug 
    class PlugExtIntegration
        # Returns :state => "state", :error => "error message"
        def self.get_state(feed_id)
            aio = get_aio
            feed = aio.feeds.retrieve(feed_id)
            
            # If there's a specific error from Adafruit, return that
            if(defined? feed.error)
                return :state => nil, :error => feed.error
            # If feed.id id def'd, means you read the feed
            elsif(defined? feed.id)
                return :state => feed.last_value, :error => nil
            # no feed error and no feed id? Catch all...
            else
                return :state => nil, :error => "Generic error"
            end
        end
        
        # Returns true if good, :error if no good
        def self.set_state(feed_id, state)
            aio = get_aio
            feed = aio.feeds.retrieve(feed_id)
            
            if(defined? feed.error)
                return :error => feed.error
            end
            
            data = aio.feeds(feed_id).data.last
            data.value = state
            data.save
        end
        
        private
            def self.get_aio
                aio = Adafruit::IO::Client.new :key => '792e5b98480a408ca686a334b05bc68e'
            end
    end
end
