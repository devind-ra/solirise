class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @appraisals = current_user.appraisals.includes(:entries)
    @pending_appraisals = @appraisals.select { |a| a.entries.empty? }
  end
end
