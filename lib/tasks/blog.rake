
namespace :blog do
  desc "Update the blog"
  task update: :environment do
    UpdateBlog.perform_now
  end
end
