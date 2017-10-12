ActiveAdmin.register Homepage do
  menu label: "Homepage", priority: 1
  actions :all, except: [:create, :destroy]

  permit_params :welcome, :articles_intro,
    featured_topic_content_attributes: [
      :id, :_destroy, :content_type, :content_id_string, :position
    ],
    featured_article_content_attributes: [
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

    f.actions
  end
end
