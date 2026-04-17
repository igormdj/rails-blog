class TagsController < ApplicationController
  def index
    @tags = Tag.all.order(:name)
  end

  def show
    @tag = Tag.find(params[:id])
    @posts = @tag.posts.recentes.page(params[:page]).per(10)
  end
end
