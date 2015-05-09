class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :school_id
      t.integer :house_id
      t.string :badge_id
      t.string :email
      t.string :name

      t.timestamps
    end
  end
end
