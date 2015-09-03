# == Schema Information
#
# Table name: point_assignments
#
#  id          :integer          not null, primary key
#  staff_id    :integer
#  house_id    :integer
#  activity_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  deleted_at  :datetime
#  note        :text
#  member_id   :integer
#

require 'test_helper'

class PointAssignmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
