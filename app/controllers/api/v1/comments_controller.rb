class Api::V1::CommentsController < ApplicationController
  before_action :load_article
  before_action :load_comment, only: [:show]

  def index
    render json: CommentSerializer.render(@article.comments)
  end

  def show
    render json: CommentSerializer.render(@comment)
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

  def load_comment
    id = params[:id]

    begin
      @comment = Comment.find(id)
    rescue ActiveRecord::RecordNotFound
      render json: { error: "No comment with ID #{id}" }, status: :not_found
    end
  end
end