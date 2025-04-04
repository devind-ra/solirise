class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @appraisals = current_user.appraisals
  end
end
