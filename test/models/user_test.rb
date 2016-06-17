require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example user", email: "user@example.com", password: "password", password_confirmation: "password")
  end

  # Ensure basic validation
  test "should be valid" do
    assert @user.valid?
  end  
  
  # Ensure all required value checks
  test "all required values must be present" do
    ensure_presence_of_values(@user)
  end
  
  # Ensure passwords fit model defined criteria
  test "user password fits criteria" do
    user_password_checks(@user)
  end
  
  test "user email must be unique" do
    duplicate_user = @user.dup
    
    # Before save, duplicate user should be valid
    assert duplicate_user.valid?
    
    # Save @user, now duplicate user should be invalid
    @user.save
    assert_not duplicate_user.valid?
    
    # Check for case-insensitive email
    duplicate_user.email = duplicate_user.email.upcase
    assert_not duplicate_user.valid?
  end
  

  
  private
    def ensure_presence_of_values(user)
      test_user = user.dup
      test_user.name = "      "
      assert_not test_user.valid?, "user name required"
      
      test_user = user.dup
      test_user.email = "        "
      assert_not test_user.valid?, "user email required"
      
      test_user = user.dup
      test_user.password = ""
      assert_not test_user.valid?, "user password required"
      
      test_user = user.dup
      test_user.password_confirmation = ""
      assert_not test_user.valid?, "user password_confirmation required"
    end
    
    def user_password_checks(user)
      test_user = user.dup
      test_user.password = "password_1"
      test_user.password_confirmation = "notthesame"
      assert_not test_user.valid?, "user password and password_confirmation must match"
  
      test_user = user.dup
      test_user.password = test_user.password_confirmation = " " * 6
      assert_not test_user.valid?, "user password can't consist of spaces"
      
      test_user = user.dup
      test_user.password = test_user.password_confirmation = ""
      assert_not test_user.valid?, "user password can't be blank"
  
      test_user = user.dup
      test_user.password = test_user.password_confirmation = "a" * 5
      assert_not test_user.valid?, "user password must be at least 5 characters"
      
      test_user = user.dup
      test_user.password = test_user.password_confirmation = "a" * 6
      assert test_user.valid?, "user password should be valid with 6 characters"
    end
    
    def user_email_checks(user)
      duplicate_user = user.dup
      
      # Save @user, now duplicate user should be invalid
      @user.save
      assert_not duplicate_user.valid?
      
      # Check for case-insensitive email
      duplicate_user.email = duplicate_user.email.upcase
      assert_not duplicate_user.valid?
    end
end
