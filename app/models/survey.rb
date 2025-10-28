class Survey < ApplicationRecord
  belongs_to :user
  has_many :questions
  has_many :responses
  
  # Status enum with all required states
  # 0 = draft, 1 = published, 2 = paused, 3 = archived
  enum :status, { draft: 0, published: 1, paused: 2, archived: 3 }
end
