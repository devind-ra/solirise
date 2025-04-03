# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
grade1_categories_with_questions = {
  'Consultant behaviour' => [
    '1) Has demonstrated analytical thinking, attention to detail, and critical/creative thinking skills for problem solving. (Problem-solving)',
    '2) Has showcased a high degree of readiness and is responsible for taking action points to completion. (Meetings/workshops)',
    '3) Has demonstrated clear/concise writing skills, creative presentation skills, and the ability to adapt to different communication styles. (Communication)',
    '4) Has demonstrated the ability to manage multiple commitments, ensuring that a high standard of work is maintained in the face of pressure. Uses time management and organisational techniques. (Work/time management)',
    '5) Is aware of their stress-management, can understand complex situations and can reflect on their actions both positively and constructively. (Emotional Intelligence)',
    '6) Actively participates in teams, forms reliable relationships and can utilise those bonds. (Teamwork)',
    '7) Ability to listen, translate instructions into actions, and complete what has been requested. (Work/time management)',
    '8) Identifies what is important to the client and combines this with their own knowledge/experience to generate new insights, ideas, and actions. (Creativity)' ],
  'Client side delivery' => [
    '1) Has successfully delivered client work.',
    '2) Has good feedback from assignment manager or account manager',
    '3) Has worked well in a team with supervision.',
    '4) Has communicated well (verbally and in written form) often and early.' ],
  'Expertise level in chosen field' => [
    '1) Has identified an area to focus on.',
    '2) Has participated in at least one project.',
    '3) Has delivered client side or internal work in chosen field.' ],
  'Developing oneself' => [
    '1) Has been on practice specific training',
    '2) Has been on the Solirius consultant training',
    '3) Has developed a training plan with their line manager.',
    '4) Is actively learning a technology or a skill in their own time.',
    '5) Has adapted to using G-Suite services (and what your client is using)' ],
  'Wider contribution to the company' => [
    '1) Participate or contribute to a Solirius practice.',
    '2) Attend lunch and learns or technical talks.',
    '3) Has good visibility amongst other consultants within the company',
    '4) Has conducted themselves with highest level of professional and moral conduct.',
    '5) Has made a positive contribution to a Workstream',
    '6) Has completed the Information Security training and approved policies on Hi Comply' ],
  'Developing others' => [
    '1) Has supported new joiners',
    '2) Has supported team members',
    '3) Has good feedback from peers' ],
  'Amount of time spent on client work (approximate)' => [
    '1) At least 60% of time spent on client work?',
    '2) Good punctuality/attendance' ],
  'General Feedback' => []
}

grade1_categories_with_questions.each do |category_name, questions|
  # Find or create the category
  category = Category.find_or_create_by!(name: category_name)

  # Loop through the questions and associate them with the category
  questions.each do |content|
    category.questions.find_or_create_by!(content: content)
  end
end
