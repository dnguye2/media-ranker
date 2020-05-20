class User < ApplicationRecord
  # Validations
  validates :username, presence: true

  # Relationships
  has_many :votes, dependent: :destroy
  has_many :works, :through => :votes
end
