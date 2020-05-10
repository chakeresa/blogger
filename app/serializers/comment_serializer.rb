class CommentSerializer
  def self.render(comment_or_comments)
    comment_or_comments.as_json(only: [
      :article_id,
      :author_name,
      :body,
      :id,
    ])
  end
end
