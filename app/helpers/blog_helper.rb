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

  def cache_key_for_blog_posts(blog_posts)
    [BlogPost.all.cache_key, @blog_posts.current_page, params[:tag]]
  end
end
