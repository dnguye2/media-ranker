class Vote < ApplicationRecord
  # Validations
  validates :user_id, presence: true
  validates :work_id, presence: true

  # Relationships
  belongs_to :user
  belongs_to :work
end
