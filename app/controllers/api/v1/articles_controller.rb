class Api::V1::ArticlesController < ApplicationController
  def index
    render json: ArticleSerializer.render(Article.all)
  end
end
