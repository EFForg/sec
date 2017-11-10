ActiveAdmin.register Homepage do
  menu label: "Homepage", parent: "Pages", priority: 1
  actions :all, except: [:create, :destroy]

  permit_params :welcome, :update_notes,
    :articles_intro,
    :lessons_intro,
    :materials_intro,
    :blog_intro,
    featured_topic_content_attributes: [
      :id, :content_id, :position
    ],
    featured_article_content_attributes: [
      :id, :content_id, :position
    ],
    featured_material_content_attributes: [
      :id, :content_id, :position
    ],
    featured_blog_post_content_attributes: [
      :id, :content_id, :position
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

    f.actions
  end
end
