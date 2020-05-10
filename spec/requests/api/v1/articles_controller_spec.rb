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

  describe "POST #create" do
    describe 'with valid attributes' do
      before(:each) do
        @valid_attrs = {
          title: Faker::Dessert.flavor,
          body: Faker::Lorem.paragraph(
            sentence_count: 3,
            supplemental: true,
            random_sentences_to_add: 3
          )
        }

        post "/api/v1/articles", params: {article: @valid_attrs}
      end
  
      it "returns 201" do
        expect(response).to have_http_status(201)
      end
  
      it "outputs data for the new article" do
        article = JSON.parse(response.body)
  
        expect(article.class).to eq(Hash)
  
        expect(article["title"]).to eq(@valid_attrs[:title])
        expect(article["body"]).to eq(@valid_attrs[:body])
        expect(article["id"]).to eq(Article.last.id)
      end
    end

    describe 'with invalid attributes' do
      before(:each) do
        @invalid_attrs = {
          title: Faker::Dessert.flavor
          # no body given
        }

        post "/api/v1/articles", params: {article: @invalid_attrs}
      end
  
      it "returns 422" do
        expect(response).to have_http_status(422)
      end
  
      it "lists errors" do
        json = JSON.parse(response.body)
  
        expect(json.class).to eq(Hash)
  
        expect(json["errors"]).to eq({"body" => ["can't be blank"]})
      end
    end
  end
end
