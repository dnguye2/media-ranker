class User < ApplicationRecord
  # Validations
  validates :username, presence: true

  # Relationships
  has_many :votes
  has_many :works, :through => :votes
end
