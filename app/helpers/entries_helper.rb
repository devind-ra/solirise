module EntriesHelper
    def generate_pdf(entry, appraisal, categories)
      pdf = Prawn::Document.new

      pdf.text "Appraisal: #{appraisal.title}", size: 14
      pdf.text "User: #{appraisal.user.first_name} #{appraisal.user.last_name}", size: 12
      pdf.text "Email: #{appraisal.user.email}", size: 12
      pdf.move_down 10

      section_started = false

      categories.each_with_index do |category, idx|
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
            pdf.text "#{question.content}", size: 10
            pdf.move_down 5
          end
        end

        answer = entry.answers&.[](category.id.to_s) || "No answer provided"
        pdf.text "Answer:", size: 12, style: :bold
        pdf.move_down 2
        pdf.text "#{answer}", size: 12
        pdf.move_down 15
      end
      pdf
    end
end
