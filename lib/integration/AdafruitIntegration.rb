module AdafruitIntegration
    # Use this as the interface to whatever service is being used
    require 'adafruit/io'

    def self.get_external_state(feed_id)
        aio = Adafruit::IO::Client.new :key => '792e5b98480a408ca686a334b05bc68e'
        return aio.feeds.retrieve("ac").last_value
    end
        
end

