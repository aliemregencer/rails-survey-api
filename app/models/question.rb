class Question < ApplicationRecord
  belongs_to :survey
  has_many :options
  has_many :answers
  
  enum :question_type, { free_text: 0, multiple_choice: 1, likert: 2 }
end
