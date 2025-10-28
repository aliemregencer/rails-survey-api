class Answer < ApplicationRecord
    belongs_to :response 
    belongs_to :question 
    # Cevabın metnini tutacak bir `content` alanına ihtiyacı var.
  end