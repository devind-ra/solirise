class Answer < ApplicationRecord
  belongs_to :entry
  belongs_to :question
end
