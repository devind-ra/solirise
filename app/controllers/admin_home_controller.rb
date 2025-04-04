class AdminHomeController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  
  def index
    @appraisals = Appraisal.all
  end

  private

  def check_admin
    redirect_to home_path, alert: "You are not authorised to view the admin page" unless current_user.admin?
  end
end
