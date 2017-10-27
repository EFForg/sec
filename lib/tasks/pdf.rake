
namespace :pdfs do
  desc "Recreate all lesson pdfs"
  task recreate: :environment do
    Lesson.find_each do |lesson|
      lesson.save
      sleep 0.5
    end
  end
end
