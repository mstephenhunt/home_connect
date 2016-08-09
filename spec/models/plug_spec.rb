# spec/models/plug.rb
require 'spec_helper'

RSpec.describe Plug, type: :model do
    it { should belong_to(:user) }
    it { should validate_presence_of(:feed_id) }
    it { should validate_presence_of(:name) }
    #it { should validate_inclusion_of(:state).in_array(['ON', 'OFF', 'ERR']) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:user) }        

                ### Method Validations ###
    describe '.get_state()' do
        before(:each) do
            @user = FactoryGirl.create(:user_with_plug)
            @plug = @user.plugs.find_by(user_id: @user.id)
        end
        
        it 'can get state with good setup' do
            expect(@plug.get_state[:state]).to eq("ON").or eq("OFF")
        end
        
        it 'gets an error if given no feed id' do
            @plug.feed_id = nil
            
            expect(@plug.get_state[:error]).not_to be_nil
        end
        
        it 'gets an error if given a bad feed id' do
            @plug.feed_id = "bad_id"
            
            expect(@plug.get_state[:error]).not_to be_nil
        end
    end
    
    describe '.flip_plug()' do
        before(:each) do
            @user = FactoryGirl.create(:user_with_plug)
            @plug = @user.plugs.find_by(user_id: @user.id)
        end
        
        it 'changes from one state to another' do
            initial_state = @plug.get_state
            @plug.flip_plug
            new_state = @plug.get_state
            

            if(initial_state == "ON")
                expect(new_state).to eq("OFF")
            elsif(initial_state == "OFF")
                expect(new_state).to eq("ON")
            end
        end
        
        it 'caches the changed state' do
            local_initial_state = @plug.state
            @plug.flip_plug
            local_new_state = @plug.state
            
            if(local_initial_state == "ON")
                expect(local_new_state).to eq("OFF")
            elsif(local_initial_state == "OFF")
                expect(local_new_state).to eq("ON")
            end
        end
        
        it 'returns :error if a bad plug id' do
            @plug.feed_id = "bad_id"
            expect(@plug.flip_plug).to have_key(:error)
        end
    end
    
    describe '.save()' do
        before(:each) do
            @user = FactoryGirl.create(:user_with_plug)
            @plug = @user.plugs.find_by(user_id: @user.id)
        end
    
        it 'initializes new plugs with the correct state in memory' do
            # setup comes from factory girl
            
            # evaluate
            expect(@plug.get_state[:state]).not_to be_nil
            expect(@plug.get_state[:state]).to eq(@plug.state)
        end
        
        it 'initializes new plugs with the correct state in the DB' do
            # setup
            @cached_plug = Plug.find_by(@plug.id)
            
            # evaluate
            expect(@plug.get_state[:state]).not_to be_nil
            expect(@plug.get_state[:state]).to eq(@cached_plug.state)
        end        
    end
end