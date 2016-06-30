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
        
        it 'returns nil if a bad plug id' do
            @plug.feed_id = "bad_id"
            
            expect(@plug.flip_plug).to be_nil
        end
        
        it 'initializes new plugs with the correct state' do
            plug = Plug.new(feed_id: "int_test")
            
            expect(plug.get_state[:state]).to eq(@plug.state)
        end
        
        it 'caches the current state in the db before a flip' do
            db_plug = Plug.find_by(@plug.id)
                
            expect(db_plug.state).to eq(@plug.state)
        end
        
        it 'caches the current state in the db after a flip' do
            @plug.flip_plug
            db_plug = Plug.find_by(@plug.id)
                
            expect(db_plug.state).to eq(@plug.state)
        end
    end
end