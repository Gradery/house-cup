# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  key        :string(255)
#  value      :string(255)
#  school_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#

require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
