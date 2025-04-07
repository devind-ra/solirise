class EntriesController < ApplicationController
  before_action :set_appraisal, only: [ :new, :create, :edit, :update, :view ]
  before_action :set_entry, only: [ :edit, :update ]

  # def index
  #     @entries = Entry.all
  # end

  def new
      @entry = Entry.new
      @categories = Category.includes(:questions)
  end

  def create
    @entry = @appraisal.entries.build(entry_params)

    if @entry.answers.values.any?(&:blank?)
      @entry.save(validate: false)
  
      redirect_to home_path, notice: "Entry saved as draft. You can continue filling out the answers."
    else
      if @entry.save
        redirect_to home_path, notice: "Entry submitted successfully!"
      else
        render :new
      end
    end
  end

  def view
    @categories = Category.includes(:questions)
    if params[:appraisal_id]
      @appraisal = Appraisal.find(params[:appraisal_id])
      @entry = @appraisal.entries.last
    else
      @entry = Entry.find(params[:id])
      @appraisal = @entry.appraisal
      @categories = Category.includes(:questions)
    end
  end

  def edit
    @categories = Category.includes(:questions)
  end

  def update
    if @entry.update(entry_params)
      if @entry.answers.values.any?(&:blank?)
        redirect_to home_path, notice: "Entry saved as draft. You can continue later."
      else
        redirect_to home_path, notice: "Entry submitted successfully!"
      end
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
    @appraisal = Appraisal.find(params[:appraisal_id] || params[:id])
  end

  def set_entry
    @entry = @appraisal.entries.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(answers: {})
  end
end
