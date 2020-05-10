class ArticleSerializer < BaseSerializer
  MODEL_CLASS = Article
  ATTRIBUTES = [
    :body,
    :id,
    :title
  ]
end
