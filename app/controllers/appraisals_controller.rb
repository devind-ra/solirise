class AppraisalsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    before_action :set_appraisal, only: [ :destroy ]

    def new
        @appraisal = Appraisal.new
    end

    def create
        @appraisal = Appraisal.new(appraisal_params)
        @appraisal.user = User.find(params[:user_id]) if params[:user_id].present?
        if @appraisal.save
            redirect_to admin_home_index_path, notice: "Appraisal created for #{@appraisal.user.first_name} #{@appraisal.user.last_name}."
        else
            render :new, alert: "Failed to create appraisal."
        end
    end

    def view
        @appraisals = current_user.appraisals.includes(:entries).order(updated_at: :desc)
    end

    def destroy
        if @appraisal.destroy
            redirect_to admin_home_index_path, notice: "Appraisal successfully deleted."
        else
            redirect_to admin_home_index_path, alert: "Failed to delete appraisal."
        end
    end

    private

    def set_appraisal
        @appraisal = Appraisal.find(params[:id])
    end

    def check_admin
        redirect_to home_path, alert: "You are not authorised to perform this action" unless current_user.admin?
    end

    def appraisal_params
        params.require(:appraisal).permit(:title)
    end
end
