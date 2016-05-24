class AddAdafruitDetailsToPlugs < ActiveRecord::Migration
  def change
    add_column :plugs, :feed_id, :string
  end
end
