class Api::V1::ArticlesController < ApplicationController
  def index
    render json: ArticleSerializer.render(Article.all)
  end

  def show
    render json: ArticleSerializer.render(Article.find(params[:id]))
  end
end
