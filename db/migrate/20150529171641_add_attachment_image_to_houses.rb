class AddAttachmentImageToHouses < ActiveRecord::Migration
  def self.up
    change_table :houses do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :houses, :image
  end
end
