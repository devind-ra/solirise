require 'prawn'

class EntriesController < ApplicationController
  before_action :set_appraisal, only: [ :new, :create, :edit, :update, :view, :download ]
  before_action :set_entry, only: [ :edit, :update, :view, :download ]

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

  def download
    @entry = Entry.find(params[:id])
    @appraisal = @entry.appraisal
    @categories = Category.includes(:questions)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = Prawn::Document.new
  
        pdf.text "Appraisal: #{@appraisal.title}", size: 14
        pdf.text "User: #{@appraisal.user.first_name} #{@appraisal.user.last_name}", size: 12
        pdf.text "Email: #{@appraisal.user.email}", size: 12
        pdf.move_down 10

        section_started = false
        current_page = nil 
  
        @categories.each_with_index do |category, idx|
          if category.page != section_started
            section_started = category.page
  
            pdf.start_new_page unless section_started == 1
  
            pdf.text "Section #{category.page}", size: 16, style: :bold
            pdf.move_down 10
          end
  
          pdf.text "#{category.name}", size: 14, style: :italic
          pdf.move_down 5
  
          if category.questions.any?
            category.questions.each do |question|
              pdf.text "#{question.content}"
              pdf.move_down 5
            end
          end
          answer = @entry.answers&.[](category.id.to_s) || "No answer provided"
          pdf.text "Answer:", size: 12, style: :bold
          pdf.move_down 2
          pdf.text "#{answer}", size: 12
          pdf.move_down 15
        end
        send_data pdf.render, filename: "Appraisal_Entry_#{@entry.id}.pdf", type: 'application/pdf', disposition: 'attachment'
      end
    end
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
