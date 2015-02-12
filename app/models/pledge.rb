# == Schema Information
#
# Table name: pledges
#
#  id           :integer          not null, primary key
#  amount       :integer
#  reason       :string
#  user_id      :integer
#  challenge_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Pledge < ActiveRecord::Base
  belongs_to :user
  belongs_to :challenge

  def is_owner?(user)
    self.user_id == user.try(:id)
  end
end
