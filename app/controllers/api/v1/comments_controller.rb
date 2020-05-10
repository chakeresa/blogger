class Api::V1::CommentsController < ApplicationController
  before_action :load_article

  def index
    render json: CommentSerializer.render(@article.comments)
  end

  private

  def load_article
    id = params[:article_id]

    begin
      @article = Article.find(id)
    rescue ActiveRecord::RecordNotFound
      render json: { error: "No article with ID #{id}" }, status: :not_found
    end
  end
end