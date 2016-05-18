class User < ActiveRecord::Base
    # Equiv Statement, validates is just a method:
    # validates(:name, presence: true);
    validates   :name, presence: true
    validates   :email, presence: true,
                uniqueness: true
                
    has_secure_password
end
