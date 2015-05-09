# == Schema Information
#
# Table name: members
#
#  id         :integer          not null, primary key
#  school_id  :integer
#  house_id   :integer
#  badge_id   :string(255)
#  email      :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
