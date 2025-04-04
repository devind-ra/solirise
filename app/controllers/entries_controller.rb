class EntriesController < ApplicationController
  before_action :set_appraisal, only: [ :new, :create, :edit, :update ]
  before_action :set_entry, only: [ :edit, :update ]

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
      redirect_to home_path, notice: "Entry submitted successfully!"
    else
      render :new
    end
  end

  def edit
    @categories = Category.includes(:questions)
  end

  def update
    if @entry.update(entry_params)
      redirect_to home_path, notice: "Entry updated successfully!"
    else
      render :edit
    end
  end

  def destroy
      Entry.find(params[:id]).destroy
      redirect_to home_path
  end

  private

  def set_appraisal
    @appraisal = Appraisal.find(params[:appraisal_id])
  end

  def set_entry
    @entry = @appraisal.entries.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(answers: {})
  end
end
