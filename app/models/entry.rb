class Entry < ApplicationRecord
    belongs_to :appraisal
    validates :appraisal, presence: true

    after_create :update_appraisal_timestamp
    after_update :update_appraisal_timestamp

    private

    def update_appraisal_timestamp
      appraisal.touch
    end
end
