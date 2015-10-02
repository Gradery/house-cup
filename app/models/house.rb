# == Schema Information
#
# Table name: houses
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  color              :string(255)
#  points             :integer
#  school_id          :integer
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  deleted_at         :datetime
#

class House < ActiveRecord::Base
	acts_as_paranoid
	
	belongs_to :school
	has_many :members
	has_many :staff

	has_attached_file :image, :default_url => "/img/:style/missing.png",
				  :styles => {thumbnail: "1000x1000ß"},
                  :default_style => :thumbnail, 
                  :content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] }
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  	validates :name, :color, :points, :school_id, presence: true
end
