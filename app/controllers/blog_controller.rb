class BlogController < ApplicationController
  include ContentPermissioning
  include Tagging

  breadcrumbs "Security Education" => routes.root_path,
              "Blog" => routes.blog_path

  def index
    @blog_posts = blog_post_scope.preload(:tags).
                  published.order(published_at: :desc).
                  page(params[:page])
  end

  def show
    @blog_post = BlogPost.friendly.find(params[:id])
    protect_unpublished! @blog_post
    breadcrumbs @blog_post.name
  end

  private

  def taggable_type
    BlogPost
  end

  def blog_post_scope
    if params[:tag]
      BlogPost.tagged_with(params[:tag]).distinct
    else
      BlogPost.all
    end
  end
end
