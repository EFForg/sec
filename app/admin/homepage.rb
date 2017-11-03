ActiveAdmin.register Homepage do
  menu label: "Homepage", parent: "Pages", priority: 1
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
    featured_material_content_attributes: [
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

  breadcrumb do
    [link_to("Admin", "/admin"), link_to("Homepage")]
  end

  form do |f|
    inputs{ input :welcome, as: :ckeditor }

    inputs "Articles" do
      input :articles_intro, as: :ckeditor

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
    end

    inputs "Lessons" do
      input :lessons_intro, as: :ckeditor

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
    end

    inputs "Training Materials" do
      input :materials_intro, as: :ckeditor

      f.inputs "Featured Materials" do
        material_options = Material.all.map{ |t| "#{t.name} (##{t.id})" }
        f.has_many :featured_material_content,
                   heading: nil,
                   new_record: "Add New Featured Material",
                   allow_destroy: true,
                   sortable: :position do |t|
          t.input :content_type, as: :hidden,
                  input_html: { value: "Material" }
          t.input :content_id_string, as: :datalist,
                  label: "Material", collection: material_options
        end
      end
    end

    inputs "Blog" do
      input :blog_intro, as: :ckeditor

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
    end

    f.actions
  end
end
