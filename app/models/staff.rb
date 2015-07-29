# == Schema Information
#
# Table name: staffs
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  school_id              :string(255)
#  house_id               :integer
#  grade                  :string(255)
#

class Staff < ActiveRecord::Base
  acts_as_paranoid
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, :school_id, :house_id, presence: true
  validates :password, :password_confirmation, presence: true, on: :create
  validates :password, confirmation: true

  belongs_to :school
  belongs_to :house

  def to_s
  	email
  end
end
