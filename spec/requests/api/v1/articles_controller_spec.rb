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
      @first_article = create(:article)
      create_list(:article, 2)

      get "/api/v1/articles/#{@first_article.id}"
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "outputs data for a single article" do
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

        post "/api/v1/articles", params: { article: @valid_attrs }
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

        post "/api/v1/articles", params: { article: @invalid_attrs }
      end
  
      it "returns 422" do
        expect(response).to have_http_status(422)
      end
  
      it "lists errors" do
        json = JSON.parse(response.body)
  
        expect(json.class).to eq(Hash)
  
        expect(json["errors"]).to eq({ "body" => ["can't be blank"] })
      end
    end
  end

  describe "DELETE #destroy" do
    describe 'with a valid ID' do
      before(:each) do
        @article = create(:article)
        delete "/api/v1/articles/#{@article.id}"
      end

      it "returns 204 (no content)" do
        expect(response).to have_http_status(204)
        expect(response.body).to eq('')
      end
    end

    describe 'with an invalid ID' do
      before(:each) do
        article = create(:article)
        @id = article.id + 1
        delete "/api/v1/articles/#{@id}"
      end

      it "returns 404" do
        expect(response).to have_http_status(404)
      end

      it "returns an error" do
        body = JSON.parse(response.body)

        expect(body).to eq(
          {"error" => "No article with ID #{@id}"}
        )
      end
    end
  end

  describe "PATCH #update" do
    describe 'with valid attributes' do
      before(:each) do
        @article = create(:article)
        @valid_attrs = { title: Faker::Dessert.flavor }

        patch "/api/v1/articles/#{@article.id}", params: { article: @valid_attrs }
      end
  
      it "returns 200" do
        expect(response).to have_http_status(200)
      end
  
      it "outputs data for the updated article" do
        article = JSON.parse(response.body)
  
        expect(article.class).to eq(Hash)
  
        expected_hash = {
          "title" => @valid_attrs[:title],
          "body" => @article.body,
          "id" => @article.id
        }

        expect(article).to eq(expected_hash)
      end
    end

    describe 'with invalid attributes' do
      before(:each) do
        @article = create(:article)
        @invalid_attrs = { title: nil }

        patch "/api/v1/articles/#{@article.id}", params: { article: @invalid_attrs }
      end
  
      it "returns 422" do
        expect(response).to have_http_status(422)
      end
  
      it "lists errors" do
        json = JSON.parse(response.body)
  
        expect(json.class).to eq(Hash)
  
        expect(json["errors"]).to eq({ "title" => ["can't be blank"] })
      end
    end
  end
end
