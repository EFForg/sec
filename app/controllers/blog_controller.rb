class BlogController < ApplicationController
  breadcrumbs "Security Education" => routes.root_path,
              "Blog" => routes.blog_path

  def index
    @blog_posts = BlogPost.order(published_at: :desc).page(params[:page])
  end

  def show
    @blog_post = BlogPost.friendly.find(params[:id])
    breadcrumbs @blog_post.name
  end
end
