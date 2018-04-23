require "shellwords"

class PdfTemplate
  Error = Class.new(Exception)

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

    command = ["bin/html-pdf-chrome",
               "--html=#{input}",
               "--pdf=#{output.path}"]

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
end
