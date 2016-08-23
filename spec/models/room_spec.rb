# spec/models/rooms_spec.rb
require 'spec_helper'

RSpec.describe Room, type: :model do
    it { should belong_to(:user) }
    it { should have_many(:plugs) }
    it { should validate_presence_of(:name) }
end