# spec/models/plug.rb
require 'spec_helper'

describe Plug, type: :model do
    it { should belong_to(:user) }
    
    describe '.name' do
        it { should validate_presence_of(:name) }
    end
    
    describe '.name' do
        it { should validate_presence_of(:feed_id) }
    end
    
    describe '.state' do
        it do
            should validate_inclusion_of(:state).
             in_array(['on', 'off'])
        end
    end
    
    describe '.user_id' do
        it { should validate_presence_of(:user_id) }
    end
    
    describe 'user' do
        it { should validate_presence_of(:user) }
    end
    
                ### Method Validations ###
    describe '.get_state()' do
        before(:each) do
            @user = FactoryGirl.create(:user_with_plug)
        end
        
        it 'can get state with good setup' do
            state = @user.plugs.find_by(user_id: @user.id).
             get_state
            expect(state).to eq("ON").or eq("OFF")
        end
        
        it 'gets an error if given no feed id' do
            expect(Plug.new.get_state).to eq("Generic error")
        end
        
        it 'gets an error if given a bad feed id' do
            plug = @user.plugs.find_by(user_id: @user.id)
            plug.feed_id = "bad_id"
            expect(plug.get_state).to start_with("not found")
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
    end
end