
namespace :pdfs do
  desc "Recreate all lesson pdfs"
  task recreate: :environment do
    Lesson.published.find_each do |lesson|
      UpdateLessonPdf.perform_now(lesson.id)
    end
  end
end
