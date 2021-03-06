# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  profile_image   :text
#  password_digest :string
#  created_at      :datetime
#  updated_at      :datetime
#  is_admin        :boolean          default("false")
#

class User < ActiveRecord::Base
  has_secure_password

  validates :name, :presence => true, :uniqueness => true

  validates :password, presence: true, length: { minimum: 6 }, on: :create

  mount_uploader :profile_image, ProfileImageUploader

  has_many :challenges
  has_many :pledges
end
