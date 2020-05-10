class ArticleSerializer
  def self.render(article_or_articles)
    if article_or_articles.class == Article
      self.render_single(article_or_articles)
    else
      self.render_multiple(article_or_articles)
    end
  end

  private

  def self.render_single(article)
    article.slice(
      :body,
      :id,
      :title
    )
  end

  def self.render_multiple(articles)
    articles.map do |article|
      self.render_single(article)
    end
  end
end
