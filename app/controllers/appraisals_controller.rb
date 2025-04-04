class AppraisalsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    before_action :set_appraisal, only: [ :destroy ]

    def destroy
        if @appraisal.destroy
            redirect_to admin_home_path, notice: "Appraisal successfully deleted."
        else
            redirect_to admin_home_path, alert: "Failed to delete appraisal."
        end
    end

    private

    def set_appraisal
        @appraisal = Appraisal.find(params[:id])
    end

    def check_admin
        redirect_to home_path, alert: "You are not authorised to perform this action" unless current_user.admin?
    end
end
