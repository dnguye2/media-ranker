class User < ApplicationRecord
  # Validations
  validates :username, presence: true
end
