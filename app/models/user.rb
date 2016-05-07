class User < ActiveRecord::Base
  has_many :proteges, class_name: "User", foreign_key: "sponsor_id"
  belongs_to :sponsor, class_name: "User"
end
