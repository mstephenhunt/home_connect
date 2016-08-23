class AddRoomToPlugs < ActiveRecord::Migration
  def change
    add_reference :plugs, :room, index: true
    add_foreign_key :plugs, :rooms
  end
end