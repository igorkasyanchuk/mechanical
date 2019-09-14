class User < ApplicationRecord
  has_many :posts, class_name: "Mechanical::Model::Post"

  def full_name
    "#{first_name} #{last_name}"
  end
end
