class Survey < ApplicationRecord
  belongs_to :user
  has_many :questions
  has_many :responses
  
  enum :status, { draft: 0, published: 1 }
end
