# coding: utf-8
class Homepage # < ApplicationRecord
  def welcome
    <<-EOF
<p>Welcome to the Security Education website!</p>

<p>Here you can find training materials for all your
security education needs.</p>

<p><a href="#">I’m lost! Take me back to SSD!</a></p>

<p><a href="#">Training modules</a></p>

<p><a href="#">Being a Trainer - Advice</a></p>

<p><a href="#">Blog</a></p>

<p><a href="#">Enrichment Materials</a></p>
EOF
  end

  def teaching_advice
    <<-EOF
<p>Whether you’re a computer scientist, a community organizer or
just a curious person, Security Education’s collection of
resources has something for you.</p>
EOF
  end

  def promoted_topics
    topics = []

    4.times do
      topic = Topic.new(name: "Title")
      topic.lessons.build(duration: 0.25 + 4 * rand)
      topics << topic
    end

    topics
  end

  def promoted_articles
    [
      Article.new(name: "Social Media"),
      Article.new(name: "Phishing"),
      Article.new(name: "Passwords")
    ]
  end

  def promoted_materials
    [
      OpenStruct.new(name: "Downloadable PDFs and slides", to_partial_path: "materials/material"),
      OpenStruct.new(name: "Install Tools", to_partial_path: "materials/material")
    ]
  end

  def promoted_blog_post
    BlogPost.new(name: "Highlighted post")
  end
end
