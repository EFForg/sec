
namespace :glossary do
  desc "Update the glossary"
  task update: :environment do
    UpdateGlossary.perform_now
  end
end
