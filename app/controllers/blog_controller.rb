class BlogController < ApplicationController
  include ContentPermissioning
  include Tagging

  breadcrumbs "Security Education" => routes.root_path,
              "Blog" => routes.blog_path

  def index
    @page = Page.find_by!(name: "blog-overview")
    @blog_posts = tagged_scope.preload(:tags).
      published.order(published_at: :desc).
      page(params[:page])
  end

  def show
    @blog_post = BlogPost.friendly.find(params[:id])
    protect_unpublished! @blog_post
    breadcrumbs @blog_post.name
    og_object @blog_post
  end

  private

  def taggable_type
    BlogPost
  end
end
