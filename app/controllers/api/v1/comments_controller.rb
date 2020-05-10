class Api::V1::CommentsController < ApplicationController
  before_action :load_article
  before_action :load_comment, only: [:show, :destroy]

  def index
    render json: CommentSerializer.render(@article.comments)
  end

  def show
    render json: CommentSerializer.render(@comment)
  end

  def create
    comment = @article.comments.build(comment_params)

    if comment.save
      render json: CommentSerializer.render(comment), status: :created
    else
      render json: { errors: comment.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    render status: :no_content
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
      @comment = @article.comments.find(id)
    rescue ActiveRecord::RecordNotFound
      render json: { error: "No comment with ID #{id} for article with ID #{@article.id}" }, status: :not_found
    end
  end

  def comment_params
    params.require(:comment).permit(:author_name, :body)
  end
end