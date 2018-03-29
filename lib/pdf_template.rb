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

    doc = controller.render_to_string(controller_options)

    pdf = WickedPdf.new.pdf_from_string(doc, wicked_options)

    tmp = Tempfile.new(["pdf", ".pdf"])
    tmp.binmode
    tmp.write(pdf)
    tmp.flush
    tmp.rewind

    tmp
  end
end
