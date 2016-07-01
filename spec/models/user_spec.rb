# spec/models/user.rb
require 'spec_helper'

describe User do
                    ##### Property Validation Tests #####
    describe "(basic presence validations)" do
        it "has a valid factory" do
            expect(FactoryGirl.create(:user)).to be_valid
        end
        it "is invalid without a name" do
            expect(FactoryGirl.build(:user, name: nil)).not_to be_valid
        end
    end
    
    
    describe "(password validations)" do
        it "is invalid without password" do
            expect(FactoryGirl.build(:user, password: nil)).not_to be_valid
        end
        it "is invalid without matching password and password_confirmation" do
            expect(FactoryGirl.build(:user, password: "first_password", 
                    password_confirmation: "second_password")).not_to be_valid
        end
        it "is invalid with too short of a password" do
            expect(FactoryGirl.build(:user, password: "short", 
                    password_confirmation: "short")).not_to be_valid
        end
        it "is invalid if password and password_confirmation are both nil" do
            expect(FactoryGirl.build(:user, password: nil, 
                    password_confirmation: nil)).not_to be_valid
        end
    end
    
    
    describe "(email validations)" do
        it "is invalid without an email" do
            expect(FactoryGirl.build(:user, email: nil)).not_to be_valid
        end
        
        context "(unique email)" do
            it "is invalid with a non-unique (all lowercase) email" do
                FactoryGirl.create(:user, email: "abcd@email.com")
               expect(FactoryGirl.build(:user, email: "abcd@email.com"))
                                        .not_to be_valid
            end
            it "is invalid with a non-unique (case-insensitive) email" do
                FactoryGirl.create(:user, email: "AbCd@EmAiL.com")
                expect(FactoryGirl.build(:user, email: "abcd@email.com"))
                                         .not_to be_valid
            end
        end
    end
    
    
                        ##### Method Validation Tests #####
    describe "(user authentication)" do
        before { @user = FactoryGirl.create(:user,   
                                            email: "email@email.com",
                                            password: "password",
                                            password_confirmation: "password") 
                @find_user = User.new
               }
        it "can authenticate user with correct password" do
            # Should set self.id if found user, errors if not
            @find_user.find_and_auth_user("email@email.com", "password")
            expect(@find_user.id).to eq(@user.id)
        end
        it "can authenticate regardless of email case" do
            @find_user.find_and_auth_user("EmAiL@emAiL.COM", "password")
            
            # Should find this user with same id without errors
            expect(@find_user.id).to eq(@user.id)
            expect(@find_user.errors.any?).to be_falsey
        end
        it "cannot authenticate user with incorrect password" do
            # Should set self.id if found user, errors if not
            @find_user.find_and_auth_user("email@email.com", "wrong_pw")
            
            # Expect to not find a user id and to find errors
            expect(@find_user.id).not_to eq(@user.id)
            expect(@find_user.errors.any?).to be_truthy
        end
        it "cannot authenticate user who is not in database" do
            @find_user.find_and_auth_user("im_not_a_real_user@email.com", 
                                          "password")
            # Expect to not get back any user id and to have errors
            expect(@find_user.id).to be_nil
            expect(@find_user.errors.any?).to be_truthy
        end
    end
end