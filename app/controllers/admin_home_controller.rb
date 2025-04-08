class AdminHomeController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @appraisals = Appraisal.all.order(updated_at: :desc)
  end

  def switch_to_admin
    session[:admin_mode] = true
    redirect_to admin_home_index_path
  end

  def switch_to_user
    session[:admin_mode] = false
    redirect_to home_path
  end

  private

  def check_admin
    redirect_to home_path, alert: "You are not authorised to view the admin page" unless current_user.admin?
  end
end
