class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @appraisals = current_user.appraisals.includes(:entries)
    @pending_appraisals = @appraisals.select do |appraisal|
      appraisal.entries.empty? || appraisal.entries.any? { |entry| entry.answers.values.any?(&:blank?) }
    end
  end
end
