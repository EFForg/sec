#!/usr/bin/env sh

namespace :static do
  desc "Create a static dump of the site"
  task :generate do
    FileUtils.mkdir_p(Rails.root.join("site"))
    Dir.chdir(Rails.root.join("site"))

    url_base = "http://app:3000"
    system("wget", "#{url_base}/favicon.ico")
    system("wget", "-r", "-nH", url_base)

    # Strip query string off assets
    # so they are served with the correct mime-type
    Dir["assets/**/*.*\\\?*"].each do |f|
      FileUtils.mv(f, f.split('?', 2)[0])
    end

    # Fetch .js formats so XHR works
    Dir["**/*"].each do |f|
      path, args = f.split("?", 2)
      system("wget", "#{url_base}/#{path}.js", "-O", "#{path}.js")
    end

    # Directories may have been page that was subsequently
    # overwritten by nested resources. Fetch the URLs again
    # and drop them into $path/index.html.
    Dir["**/*"].each do |f|
      next unless File.directory?(f)
      system("wget", "#{url_base}/#{f}", "-O", "#{f}/index.html")
    end
  end
end
