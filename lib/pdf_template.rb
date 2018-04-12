class PdfTemplate
  attr_reader :controller_options, :wicked_options

  def initialize(options)
    @controller_options = {
      template: options.fetch(:template),
      layout: "layouts/pdf.html.erb"
    }

    @wicked_options = options.slice!(:template)
    wicked_options[:pdf] = wicked_options.delete(:name)
    wicked_options.reverse_merge!(
      margin: {
        top: "0.6in",
        bottom: "1in",
        left: "1in",
        right: "0.6in"
      }
    )
  end

  def render(locals)
    controller = ApplicationController.new

    locals.each do |name, value|
      controller.instance_variable_set("@#{name}", value)
    end

    doc = rebase_urls(controller.render_to_string(controller_options))

    pdf = WickedPdf.new.pdf_from_string(doc, wicked_options)

    tmp = Tempfile.new(["pdf", ".pdf"])
    tmp.binmode
    tmp.write(pdf)
    tmp.flush
    tmp.rewind

    tmp
  end

  def rebase_urls(html)
    doc = Nokogiri::HTML.fragment(html)

    if ENV["SERVER_HOST"]
      url_base = [ENV["SERVER_PROTOCOL"], ENV["SERVER_HOST"]].join("://")
      url_base = [url_base, ENV["SERVER_PORT"]].join(":") if ENV["SERVER_PORT"]

      doc.css("a, img").each do |a|
        if a["href"] && a["href"] !~ /^https?:\/\//
          path = a["href"].sub(/^\//, "")
          a["href"] = "#{url_base}/#{path}"
        end

        if a["src"] && a["src"] !~ /^https?:\/\//
          path = a["src"].sub(/^\//, "")
          a["src"] = "#{url_base}/#{path}"
        end
      end
    end

    doc.to_html
  end
end
