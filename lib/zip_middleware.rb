require "shellwords"
require "open3"

class ZipMiddleware
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    if headers["X-Archive-Files"] == "zip"
      manifest = body.each.map(&:itself).join

      archive = create_archive(manifest)
      body = Array(archive)

      headers["Content-Type"] = "application/zip"
      headers["Content-Disposition"] = "attachment"
      headers["Content-Length"] = archive.bytesize
      headers.delete("ETag")
      headers.delete("X-Archive-Files")
    end

    [status, headers, body]
  end

  def create_archive(manifest)
    Dir.mktmpdir("zip_middleware") do |dir|
      links = manifest.lines.map do |item|
        _, size, path, filename = item.strip.split(" ", 4)

        path = URI::unescape(path).remove(%r{^/+})
        filename = URI::unescape(filename)

        link = Pathname.new(dir).join(filename)

        FileUtils.ln_s(Rails.root.join("public", path), link)

        link
      end

      Rails.logger.debug("zip -j - #{Shellwords.shelljoin(links)}")
      Open3.capture2("zip -j - #{Shellwords.shelljoin(links)}")[0]
    end
  end
end
