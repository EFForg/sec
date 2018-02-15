
class UpdateGlossary < ApplicationJob
  queue_as :glossary

  def perform
    response = HTTParty.get("https://ssd.eff.org/en/glossary")
    doc = Nokogiri::HTML(response.to_s)

    doc.css(".view-glossary-list .views-row").each do |row|
      name = row.css(".views-field-name-field a").text.strip
      path = row.css(".views-field-name-field a").attr("href").value
      body = row.css(".views-field-description-field").text.strip

      response = HTTParty.get("https://ssd.eff.org#{path}")
      doc = Nokogiri::HTML(response.to_s)
      synonyms = doc.css(".field-name-field-synonym .field-item").
                 map(&:text).map(&:strip)

      body = body.lines.map{ |p| "<p>#{p.strip}</p>" }.join

      term = GlossaryTerm.find_or_create_by!(name: name)
      term.update(body: body, synonyms: synonyms)
    end
  end
end
