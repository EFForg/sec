require "rails_helper"
require "pdf_template"

RSpec.describe PdfTemplate do
  let(:template){ "topics/show" }
  let(:pdf_template){ PdfTemplate.new(template: template) }

  describe "#render" do
    let(:topic){ Topic.new }

    it "should render the template with the given instance variables" do
      doc = "<h1>It works!</h1>"

      expect(ApplicationController).to receive(:render) do |opts|
        expect(opts[:assigns]).to eq(topic: topic)
        expect(opts[:template]).to eq(template)
        expect(opts[:layout]).to eq("layouts/pdf.html.erb")
      end.and_return(doc)

      expect(pdf_template).to receive(:rebase_urls).and_return(doc)
      expect(pdf_template).to receive(:print_pdf)

      pdf_file = pdf_template.render(topic: topic)
    end
  end

  describe "#print_pdf" do
    it "should shell out to bin/html-pdf-chrome" do
      expect(Process).to receive(:spawn) do |*args|
        expect(args[0]).to eq("bin/html-pdf-chrome")
      end

      expect(Timeout).to receive(:timeout)

      pdf_template.send(:print_pdf, "/tmp/input.html")
    end
  end

  describe "#rebase_urls" do
    it "should do nothing if ENV['SERVER_HOST'] is not set" do
      expect(ENV).to receive(:[]).with("SERVER_HOST").
                      and_return(nil).
                      at_least(:once)

      html = %(<a href="/relative">anchor</a>")
      expect(pdf_template.send(:rebase_urls, html)).to eq(html)

      html = %(<img src="/relative">")
      expect(pdf_template.send(:rebase_urls, html)).to eq(html)
    end

    it "should rewrite relative urls when ENV['SERVER_HOST'] is set" do
      proto, host, port = "https", "sec.eff.org", "8"
      expect(ENV).to receive(:[]).with("SERVER_HOST").
                      and_return(host).
                      at_least(:once)
      expect(ENV).to receive(:[]).with("SERVER_PROTOCOL").
                      and_return(proto).
                      at_least(:once)
      expect(ENV).to receive(:[]).with("SERVER_PORT").
                      and_return(port).
                      at_least(:once)

      html = %(<a href="/relative">anchor</a>")
      expect(pdf_template.send(:rebase_urls, html)).
        to eq(html.sub(%r{/relative}, "https://sec.eff.org:8/relative"))

      html = %(<img src="/relative">")
      expect(pdf_template.send(:rebase_urls, html)).
        to eq(html.sub(%r{/relative}, "https://sec.eff.org:8/relative"))
    end
  end
end
