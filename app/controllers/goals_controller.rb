class GoalsController < ApplicationController
    before_action :set_goal, only: [ :edit, :update, :destroy ]

    def index
        @goals = Goal.all
    end

    def new
        @goal = Goal.new
    end

    def create
        @goal = current_user.goals.new(goal_params)
        if @goal.save
            redirect_to goals_path, notice: "Goal was successfully created."
        else
            render :new
        end
    end

    def edit
    end

    def update
        if @goal.update(goal_params)
        redirect_to goals_path, notice: "Goal updated!"
        else
        render :edit
        end
    end

    def destroy
        Goal.find(params[:id]).destroy
        redirect_to goals_path, notice: "Goal was successfully removed."
    end

    private

    def set_goal
        @goal = Goal.find(params[:id])
    end

    def goal_params
        params.require(:goal).permit(:title, :description, :progress)
    end
end
