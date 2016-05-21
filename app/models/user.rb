class User < ActiveRecord::Base
    before_save     :before_save_user
    
    has_many :plugs, dependent: :destroy
    
    validates   :name, presence: true
    validates   :email, presence: true,
                uniqueness: true
                
    has_secure_password
    
    private
        def before_save_user
            clean_email
        end
        
        def clean_email
            # downcase the whole email
            self.email = self.email.downcase
        end
end
