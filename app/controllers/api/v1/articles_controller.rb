class Api::V1::ArticlesController < ApplicationController
  before_action :load_article, only: [:show, :destroy, :update]

  def index
    render json: ArticleSerializer.render(Article.all)
  end

  def show
    render json: ArticleSerializer.render(@article)
  end

  def create
    article = Article.new(article_params)

    if article.save
      render json: ArticleSerializer.render(article), status: :created
    else
      render json: { errors: article.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    render status: :no_content
  end

  def update
    if @article.update(article_params)
      render json: ArticleSerializer.render(@article), status: :ok
    else
      render json: { errors: @article.errors }, status: :unprocessable_entity
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :body)
  end

  def load_article
    id = params[:id]

    begin
      @article = Article.find(id)
    rescue ActiveRecord::RecordNotFound
      render json: { error: "No article with ID #{id}" }, status: :not_found
    end
  end
end
