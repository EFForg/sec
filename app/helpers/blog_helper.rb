module BlogHelper
  def rebase_blog_post(doc)
    doc.css("a, img").each do |a|
      if a["href"] && a["href"] !~ /^https?:\/\//
        path = a["href"].sub(/^\//, "")
        a["href"] = %(https://www.eff.org/#{a["href"]})
      end

      if a["src"] && a["src"] !~ /^https?:\/\//
        path = a["src"].sub(/^\//, "")
        a["src"] = %(https://www.eff.org/#{a["src"]})
      end
    end
  end
end
