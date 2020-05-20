class Vote < ApplicationRecord
  # Validations
  validates :user_id, presence: true
  validates :work_id, presence: true

  # Relationships
  belongs_to :user, counter_cache: true
  belongs_to :work, counter_cache: true
end
