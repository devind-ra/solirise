class EntriesController < ApplicationController
    before_action :set_appraisal, only: [ :new, :create ]

    # def index
    #     @entries = Entry.all
    # end

    def new
        @entry = Entry.new
        @categories = Category.includes(:questions) # Loads all categories with their questions
    end

    def create
        @entry = @appraisal.entries.build(entry_params)
        if @entry.save
          redirect_to entries_path, notice: "Entry submitted successfully!"
        else
          render :new
        end
      end

    def destroy
        Entry.find(params[:id]).destroy
        redirect_to entries_path
    end

    private

    def set_appraisal
        @appraisal = Appraisal.find(params[:appraisal_id])
    end

    def entry_params
        params.require(:entry).permit(:name, answers: {}) # Store answers as JSON
    end
end
