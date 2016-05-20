class StatusRedirectController < ApplicationController
    def not_found
        redirect_to 'https://http.cat/404'
    end
end
