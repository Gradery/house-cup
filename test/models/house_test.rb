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

require 'test_helper'

class HouseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
