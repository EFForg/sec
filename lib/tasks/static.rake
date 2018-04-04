namespace :static do
  desc "Create a static dump of the site"
  task generate: :environment do
    GenerateStaticSite.perform_now
  end
end
