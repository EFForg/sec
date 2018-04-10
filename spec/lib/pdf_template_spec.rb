require "rails_helper"
require "pdf_template"

RSpec.describe PdfTemplate do
  let(:template){ "topics/show" }
  let(:pdf_template){ PdfTemplate.new(template: template) }

  describe "#render" do
    let(:topic){ Topic.new }
    let!(:controller){ ApplicationController.new }

    it "should render the template with the given instance variables" do
      doc = "<h1>It works!</h1>"

      expect(ApplicationController).to receive(:new){ controller }
      expect(controller).to receive(:instance_variable_set).
                             with("@topic", topic)
      expect(controller).to receive(:render_to_string).
                             with(layout: "layouts/pdf.html.erb",
                                  template: template).
                             and_return(doc)
      expect(pdf_template).to receive(:rebase_urls).and_return(doc)

      expect_any_instance_of(WickedPdf).
        to receive(:pdf_from_string).
            with(doc, anything)

      pdf_file = pdf_template.render(topic: topic)
      expect(pdf_file).to be_a(Tempfile)
    end
  end

  describe "#rebase_urls" do
    it "should do nothing if ENV['SERVER_HOST'] is not set" do
      expect(ENV).to receive(:[]).with("SERVER_HOST").
                      and_return(nil).
                      at_least(:once)

      html = %(<a href="/relative">anchor</a>")
      expect(pdf_template.rebase_urls(html)).to eq(html)

      html = %(<img src="/relative">")
      expect(pdf_template.rebase_urls(html)).to eq(html)
    end

    it "should rewrite relative urls when ENV['SERVER_HOST'] is set" do
      proto, host, port = "https", "sec.eff.org", "81"
      expect(ENV).to receive(:[]).with("SERVER_HOST").
                      and_return(host).
                      at_least(:once)
      expect(ENV).to receive(:[]).with("SERVER_PROTOCOL").
                      and_return(proto).
                      at_least(:once)
      expect(ENV).to receive(:[]).with("SERVER_PORT").
                      and_return(nil).
                      at_least(:once)

      html = %(<a href="/relative">anchor</a>")
      expect(pdf_template.rebase_urls(html)).
        to eq(html.sub(%r{/relative}, "https://sec.eff.org/relative"))

      html = %(<img src="/relative">")
      expect(pdf_template.rebase_urls(html)).
        to eq(html.sub(%r{/relative}, "https://sec.eff.org/relative"))
    end
  end
end
