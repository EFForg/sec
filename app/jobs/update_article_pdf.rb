require_dependency "pdf_template"

class UpdateArticlePdf < ApplicationJob
  queue_as :pdfs

  def perform(article_id)
    article = Article.find(article_id)

    pdf = PdfTemplate.new(
      name: article.name,
      template: "articles/show.pdf.erb"
    )

    article.update!(pdf: pdf.render(article: article))
  end
end
