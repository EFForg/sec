require "shellwords"

class PdfTemplate
  Error = Class.new(Exception)

  attr_reader :controller_options, :source_route

  def initialize(options)
    @controller_options = {
      template: options.fetch(:template),
      layout: "layouts/pdf.html.erb"
    }

    @source_route = options[:source]
  end

  def render(locals = {})
    controller_options = self.controller_options.merge(assigns: locals)
    doc = rebase_urls(ApplicationController.render(controller_options))

    input = Tempfile.new(["pdf", ".html"])
    input.binmode
    input.write(doc)
    input.flush
    input.rewind

    print_pdf(input.path)
  end

  private

  def print_pdf(input)
    output = Tempfile.new(["pdf", ".pdf"])

    command = [
      "bin/html-pdf-chrome",
      "--html=#{input}",
      "--pdf=#{output.path}"
    ]

    if source_route.present?
      command << "--footer=#{source}"
    end

    if ENV["CHROME_HOST"]
      command << "--chrome-host=#{ENV["CHROME_HOST"]}"
    end

    if ENV["CHROME_PORT"]
      command << "--chrome-port=#{ENV["CHROME_PORT"]}"
    end

    Rails.logger.info(Shellwords.shelljoin(command))

    begin
      pid = Process.spawn(*command)
      Timeout.timeout(3){ Process.waitpid(pid) }
    rescue Timeout::Error => e
      Process.kill("TERM", pid)
      raise e
    end

    raise Error, "html-pdf-chrome command failed" unless $?.success?

    output
  end

  def rebase_urls(html)
    doc = Nokogiri::HTML.fragment(html)

    if ENV["SERVER_HOST"]
      url_base = [ENV["SERVER_PROTOCOL"], ENV["SERVER_HOST"]].join("://")
      url_base = [url_base, ENV["SERVER_PORT"]].join(":") if ENV["SERVER_PORT"]

      doc.css("a, img, link, script").each do |a|
        if a["href"] && a["href"] !~ /^(https?:\/\/|data:)/
          path = a["href"].sub(/^\//, "")
          a["href"] = "#{url_base}/#{path}"
        end

        if a["src"] && a["src"] !~ /^(https?:\/\/|data:)/
          path = a["src"].sub(/^\//, "")
          a["src"] = "#{url_base}/#{path}"
        end
      end
    end

    doc.to_html
  end

  include Rails.application.routes.url_helpers

  def source
    if source_route.present?
      url_for(source_route)
    end
  end

  def default_url_options
    Rails.application.config.action_controller.default_url_options
  end
end
