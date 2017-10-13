ActiveAdmin.register Homepage do
  menu label: "Homepage", priority: 1
  actions :all, except: [:create, :destroy]

  permit_params :welcome,
    :articles_intro,
    :lessons_intro,
    :materials_intro,
    :blog_intro,
    featured_topic_content_attributes: [
      :id, :_destroy, :content_type, :content_id_string, :position
    ],
    featured_article_content_attributes: [
      :id, :_destroy, :content_type, :content_id_string, :position
    ],
    featured_blog_post_content_attributes: [
      :id, :_destroy, :content_type, :content_id_string, :position
    ]

  controller do
    def index
      redirect_to edit_admin_homepage_path(Homepage.take)
    end
  end

  form do |f|
    inputs do
      input :welcome, as: :ckeditor
      input :articles_intro, as: :ckeditor
      input :lessons_intro, as: :ckeditor
      input :materials_intro, as: :ckeditor
      input :blog_intro, as: :ckeditor
    end

    f.inputs "Featured Topics" do
      topic_options = Topic.all.map{ |t| "#{t.name} (##{t.id})" }
      f.has_many :featured_topic_content,
                 heading: nil,
                 new_record: "Add New Featured Topic",
                 allow_destroy: true,
                 sortable: :position do |t|
        t.input :content_type, as: :hidden,
                input_html: { value: "Topic" }
        t.input :content_id_string, as: :datalist,
                label: "Topic", collection: topic_options
      end
    end

    f.inputs "Featured Articles" do
      article_options = Article.all.map{ |t| "#{t.name} (##{t.id})" }
      f.has_many :featured_article_content,
                 heading: nil,
                 new_record: "Add New Featured Article",
                 allow_destroy: true,
                 sortable: :position do |t|
        t.input :content_type, as: :hidden,
                input_html: { value: "Article" }
        t.input :content_id_string, as: :datalist,
                label: "Article", collection: article_options
      end
    end

    f.inputs "Featured Blog Posts" do
      blog_post_options = BlogPost.all.map{ |t| "#{t.name} (##{t.id})" }
      f.has_many :featured_blog_post_content,
                 heading: nil,
                 new_record: "Add New Featured Blog Post",
                 allow_destroy: true,
                 sortable: :position do |t|
        t.input :content_type, as: :hidden,
                input_html: { value: "BlogPost" }
        t.input :content_id_string, as: :datalist,
                label: "Blog Post", collection: blog_post_options
      end
    end

    f.actions
  end
end
