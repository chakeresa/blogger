require 'rails_helper'

RSpec.describe Api::V1::ArticlesController do
  describe "GET #index" do
    before(:each) do
      @count = 5
      @first_article = create(:article)
      create_list(:article, @count - 1)
      get '/api/v1/articles'
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "outputs data for all articles" do
      articles = JSON.parse(response.body)

      expect(articles.class).to eq(Array)
      expect(articles.count).to eq(@count)

      expected_first = {
        "id" => @first_article.id,
        "title" => @first_article.title,
        "body" => @first_article.body
      }
      expect(articles.first).to eq(expected_first)
    end
  end

  describe "GET #show" do
    before(:each) do
      @count = 5
      @first_article = create(:article)
      @other_articles =  create_list(:article, @count - 1)
    end

    it "returns 200" do
      get "/api/v1/articles/#{@first_article.id}"
      expect(response).to have_http_status(200)
    end

    it "outputs data for a single article" do
      get "/api/v1/articles/#{@first_article.id}"
      article = JSON.parse(response.body)

      expect(article.class).to eq(Hash)

      expected_hash = {
        "id" => @first_article.id,
        "title" => @first_article.title,
        "body" => @first_article.body
      }
      expect(article).to eq(expected_hash)
    end
  end
end
