class CreatePlugs < ActiveRecord::Migration
  def change
    create_table :plugs do |t|
      t.references :user, index: true, foreign_key: true
      t.string :state

      t.timestamps null: false
    end
  end
end
