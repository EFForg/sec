
namespace :pdfs do
  desc "Recreate all lesson pdfs"
  task recreate: :environment do
    Lesson.find_each(&:save)
  end
end
