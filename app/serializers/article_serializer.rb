class ArticleSerializer
  def self.render(article_or_articles)
    article_or_articles.as_json(only: [
      :body,
      :id,
      :title
    ])
  end
end
