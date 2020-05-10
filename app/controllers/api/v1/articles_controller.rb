class Api::V1::ArticlesController < ApplicationController
  def index
    render json: ArticleSerializer.render(Article.all)
  end

  def show
    render json: ArticleSerializer.render(Article.find(params[:id]))
  end

  def create
    article = Article.new(article_params)

    if article.save
      render json: ArticleSerializer.render(article), status: :created
    else
      render json: {errors: article.errors}, status: :unprocessable_entity
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :body)
  end
end
