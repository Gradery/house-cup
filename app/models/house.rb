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
#  image              :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class House < ActiveRecord::Base
	belongs_to :school
	has_many :members
	has_many :staff

	has_attached_file :image, :default_url => "/img/:style/missing.png"
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  	validates :name, :color, :points, :school_id, presence: true
end
