class MarkdownArchive
  attr_accessor :articles, :topics

  def initialize(articles: Article.all, topics: Topic.all)
    self.articles = articles
    self.topics = topics
  end

  def zip
    Dir.mktmpdir do |tmp|
      tmp = Pathname.new(tmp)

      articles.each do |article|
        add_article(tmp, article)
      end

      topics.each do |topic|
        add_topic(tmp, topic)
        topic.lessons.each do |lesson|
          add_lesson(tmp, lesson)
        end
      end

      zip = Tempfile.new(["archive", ".zip"])
      File.delete(zip.to_path)

      system(
        "sh", "-c",
        "cd #{tmp} && zip -r a.zip . && mv a.zip #{zip.to_path}"
      )

      return zip.to_path
    end
  end

  private

  def add_article(tmp, article)
    doc = ArticlesController.render(
      template: "articles/show.md.erb",
      assigns: { article: article }
    )

    path = [
      "Articles",
      article.name.strip.gsub("/", "-") + ".md"
    ].join("/")

    FileUtils.mkdir_p(File.dirname(tmp.join(path)))
    File.open(tmp.join(path), "w"){ |f| f.write(doc) }
  end

  def add_topic(tmp, topic)
    doc = TopicsController.render(
      template: "topics/show.md.erb",
      assigns: { topic: topic }
    )

    path = [
      "Topics",
      topic.name.strip.gsub("/", "-") + "/Intro.md"
    ].join("/")

    FileUtils.mkdir_p(File.dirname(tmp.join(path)))
    File.open(tmp.join(path), "w"){ |f| f.write(doc) }
  end

  def add_lesson(tmp, lesson)
    doc = TopicsController.render(
      template: "lessons/show.md.erb",
      assigns: { topic: lesson.topic, lesson: lesson }
    )

    path = [
      "Topics",
      lesson.topic.name.strip.gsub("/", "-") + "/#{lesson.level.capitalize}.md"
    ].join("/")

    FileUtils.mkdir_p(File.dirname(tmp.join(path)))
    File.open(tmp.join(path), "w"){ |f| f.write(doc) }
  end
end
