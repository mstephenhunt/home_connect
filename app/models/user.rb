class User < ActiveRecord::Base
    before_save     :before_save_user
    
    has_many :plugs, dependent: :destroy
    
    has_secure_password
    validates   :name, presence: true
    validates   :email, presence: true,
                uniqueness: true
                
    def find_and_auth_user(username, password)
        user = User.find_by(email: username)
        auth = false
        
        # If you found the user, attempt to authenticate
        if user
            auth = user.authenticate(password)
        end
        
        # If there are errors, set them. Otherwise, set id on self
        if !user
            self.errors.add :email, username + ' not found'
        elsif !auth
            self.errors.add :password
        else
            self.id = user.id
        end
    end
    
    
    ############################### Private #############################    
    
    private
        def before_save_user
            clean_email
        end
        
        def clean_email
            # downcase the whole email
            self.email = self.email.downcase
        end
end
