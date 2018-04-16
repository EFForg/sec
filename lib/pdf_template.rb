require "shellwords"

class PdfTemplate
  attr_reader :controller_options

  def initialize(options)
    @controller_options = {
      template: options.fetch(:template),
      layout: "layouts/pdf.html.erb"
    }
  end

  def render(locals = {})
    controller = ApplicationController.new

    locals.each do |name, value|
      controller.instance_variable_set("@#{name}", value)
    end

    doc = rebase_urls(controller.render_to_string(controller_options))

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

    command = ["node_modules/.bin/chrome-headless-render-pdf",
               "--chrome-option=--no-sandbox",
               "--no-margins",
               "--url", "file://#{input}",
               "--pdf", output.path]

    if `which chromium-browser`.present?
      command << "--chrome-binary" << "chromium-browser"
    end

    Rails.logger.info(Shellwords.shelljoin(command))

    begin
      retries ||= 1
      pid = Process.spawn(*command)
      Timeout.timeout(3){ Process.waitpid(pid) }
    rescue Timeout::Error => e
      Process.kill("TERM", pid)
      raise e if (retries += 1) > 3
      retry
    end

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
end
