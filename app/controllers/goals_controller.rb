class GoalsController < ApplicationController
    before_action :set_goal, only: [ :edit, :update, :destroy ]
    before_action :authenticate_user!
    before_action :check_admin, only: [ :admin_view ]
    before_action :check_admin, except: [ :index, :new, :create, :edit, :update, :destroy ]

    def index
        @goals = current_user.goals.order(updated_at: :desc)
    end

    def admin_view
        if params[:user_id].present?
            @goals = Goal.includes(:user).where(user_id: params[:user_id]).order(updated_at: :desc)
        else
            @goals = Goal.includes(:user).all.order(updated_at: :desc)
        end
    end

    def new
        @goal = Goal.new
    end

    def create
        @goal = current_user.goals.new(goal_params)
        if @goal.save
            redirect_to goals_path, notice: "Goal was successfully created."
        else
            flash[:alert] = "Failed to create goal."
            render :new
        end
    end

    def edit
    end

    def update
        if @goal.update(goal_params)
            redirect_to goals_path, notice: "Goal updated!"
        else
            flash[:alert] = "Failed to update goal."
            render :edit
        end
    end

    def destroy
        Goal.find(params[:id]).destroy
        redirect_to goals_path, notice: "Goal was successfully removed."
    end

    private

    def set_goal
        @goal = Goal.find_by(id: params[:id])
        redirect_to home_path, alert: "Goal not found." unless @goal
    end

    def check_admin
        if action_name == "admin_view"
            redirect_to home_path, alert: "You are not authorised to perform this action." unless current_user.admin? && session[:admin_mode]
        end
    end

    def goal_params
        params.require(:goal).permit(:title, :description, :progress)
    end
end
