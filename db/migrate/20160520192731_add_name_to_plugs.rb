class AddNameToPlugs < ActiveRecord::Migration
  def change
    add_column :plugs, :name, :string
  end
end
