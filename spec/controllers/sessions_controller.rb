# spec/controllers/sessions_controller.rb
require 'rails_helper'

describe SessionsController do
    describe '.new()', type: :feature do
        it 'gets the new template if not logged in' do
            visit '/sessions/new'
            expect(page).to have_content('Log in')
            
            visit '/'
            expect(page).to have_content('Log in')
        end
        
        it 'redirects to user#show if logged in' do
            @user = FactoryGirl.create(:user, 
                     password: "password", password_confirmation: "password")
            visit '/sessions/new'
            fill_in 'Email', with: @user.email
            fill_in 'Password', with: "password"
            click_button 'Log in'
            
            expect(page).to have_content("User: " + @user.name)
            
            visit '/'
            expect(page).to have_content("User: " + @user.name)
            
            visit '/sessions/new'
            expect(page).to have_content("User: " + @user.name)
        end
    end
    
    describe '.create()', type: :feature do
        before(:each) do
            @user = FactoryGirl.build(:user, 
                     password: "password", password_confirmation: "password")
            visit '/' 
        end
        
        it 'prevents a non-existant user from logging in' do
            fill_in 'Email', with: @user.email
            fill_in 'Password', with: "password"
            click_button 'Log in'
            
            expect(page).to have_content("Log in")
        end
        it 'prevents a user with a bad password from logging in' do
            @user.save
            fill_in 'Email', with: @user.email
            fill_in 'Password', with: "bad_password"
            click_button 'Log in'
            
            expect(page).to have_content("Log in")
        end
    end
    
    describe '.destroy()', type: :feature do
        before(:each) do
            @user = FactoryGirl.create(:user, 
                     password: "password", password_confirmation: "password")
            visit '/'
            fill_in 'Email', with: @user.email
            fill_in 'Password', with: "password"
            click_button 'Log in'

            click_link 'Log out'
        end
        
        it 'log out redirects to the home page' do
            expect(page).to have_content("Log in")
        end
        
        it 'prevents logged out from going to their show page' do
            visit '/users/' + @user.id.to_s
            expect(page).to have_content("Log in")
        end
    end
end