class BlogController < ApplicationController
  breadcrumbs "Security Education" => routes.root_path,
              "Blog" => routes.blog_path

  def index
    @blog_posts = BlogPost.all.page(params[:page])
  end

  def show
    @blog_post = BlogPost.find(params[:id])
    breadcrumbs @blog_post.name
  end
end
