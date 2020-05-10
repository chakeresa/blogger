class CommentSerializer < BaseSerializer
  MODEL_CLASS = Comment
  ATTRIBUTES = [
    :article_id,
    :author_name,
    :body,
    :id,
  ]
end
