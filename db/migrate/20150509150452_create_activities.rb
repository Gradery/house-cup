class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.text :name
      t.integer :points
      t.integer :school_id

      t.timestamps
    end
  end
end
