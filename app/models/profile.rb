class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :myscore
end
# @s = Myscore.find_by_profile_id(17)
# @s.level = Myscore.select("level").where(profile_id: 17).last.level
# Myscore.where(profile_id: 14,  level: s, result: true).count

# @pid = Profile.find(current_user.id).id