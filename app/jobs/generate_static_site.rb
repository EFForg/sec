class GenerateStaticSite < ApplicationJob
  def perform
    FileUtils.mkdir_p(Rails.root.join("site"))
    Dir.chdir(Rails.root.join("site"))

    url_base = "http://localhost:3000"

    FileUtils.cp_r(Rails.root.join("public/."), ".")

    if Rails.env.production?
      wget("-r", "-nH",
           "--reject-regex", "assets|uploads",
           url_base)
    else
      wget("-r", "-nH", url_base)

      # Strip query string off assets
      # so they are served with the correct mime-type
      Dir["assets/**/*.*\\\?*"].each do |f|
        FileUtils.mv(f, f.split('?', 2)[0])
      end
    end

    # Do some cleanup
    # When `wget -r` downloads a file and a directory is in the output's
    # way, it saves it with a .1 (or .2, .3, etc) suffix.
    # These files are re-downloaded to index.html at the end of the job
    # so we can delete them here.
    Dir["**/*.[0-9]*"].each do |f|
      name_without_ext = File.basename(f).split(".", 2)[0]
      if File.directory?("#{File.dirname(f)}/#{name_without_ext}")
        File.delete(f)
      end
    end

    # Fetch .js formats so XHR works
    Dir["**/*"].each do |f|
      next unless File.extname(f).blank?
      next if f =~ %r{^(assets|uploads)/}

      # For the moment only lessons are fetched via XHR
      # so we can make this optimization
      next unless f =~ %r{^topics/}

      path, args = f.split("?", 2)
      wget("#{url_base}/#{path}.js", "-O", "#{path}.js")
      FileUtils.rm("#{path}.js") unless $?.success?
    end

    # Directories may have been page that was subsequently
    # overwritten by nested resources. Fetch the URLs again
    # and drop them into $path/index.html.
    Dir["**/*"].each do |f|
      next unless File.directory?(f)
      next if f =~ %r{^(assets|uploads)/}

      wget("#{url_base}/#{f}", "-O", "#{f}/index.html")
      FileUtils.rm("#{f}/index.html") unless $?.success?
    end
  end

  def wget(*args)
    system("wget", "-q", "--header", "X-No-Pdf: 1", *args)
  end
end
