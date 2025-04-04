class AppraisalsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_appraisal, only: [:show]

    def show
        if @appraisal.user != current_user
            redirect_to home_path alert: "You are not authorised to view this appraisal."
        end
    end
    
    private 

    def set_appraisal
        @appraisal = Appraisal.find(params[:id])
    end
end
