class Entry < ApplicationRecord
    belongs_to :appraisal
    validates :appraisal, presence: true
end
