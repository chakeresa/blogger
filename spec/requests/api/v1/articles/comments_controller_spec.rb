require 'rails_helper'

RSpec.describe Api::V1::CommentsController do
  describe "GET #index" do
    before(:each) do
      @article = create(:article)
      @count = 5
      comments = create_list(:comment, @count, article: @article)
      @first_comment = comments.first

      other_article = create(:article)
      create(:comment, article: other_article)

      get "/api/v1/articles/#{@article.id}/comments"
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "outputs data for all of the article's comments" do
      comments = JSON.parse(response.body)

      expect(comments.class).to eq(Array)
      expect(comments.count).to eq(@count)

      expected_first = {
        "article_id" => @article.id,
        "author_name" => @first_comment.author_name,
        "body" => @first_comment.body,
        "id" => @first_comment.id,
      }
      expect(comments.first).to eq(expected_first)
    end
  end

  describe "GET #show" do
    before(:each) do
      @article = create(:article)
      comments = create_list(:comment, 3, article: @article)
      @first_comment = comments.first

      other_article = create(:article)
      create(:comment, article: other_article)

      get "/api/v1/articles/#{@article.id}/comments/#{@first_comment.id}"
    end

    it "returns 200" do
      expect(response).to have_http_status(200)
    end

    it "outputs data for a single comment" do
      comment = JSON.parse(response.body)

      expect(comment.class).to eq(Hash)

      expected_hash = {
        "article_id" => @article.id,
        "author_name" => @first_comment.author_name,
        "body" => @first_comment.body,
        "id" => @first_comment.id,
      }
      expect(comment).to eq(expected_hash)
    end
  end

  describe "POST #create" do
    describe 'with valid attributes' do
      before(:each) do
        @article = create(:article)

        @valid_attrs = {
          author_name: Faker::Superhero.name,
          body: Faker::Movies::StarWars.quote
        }

        post "/api/v1/articles/#{@article.id}/comments", params: { comment: @valid_attrs }
      end
  
      it "returns 201" do
        expect(response).to have_http_status(201)
      end
  
      it "outputs data for the new comment" do
        comment = JSON.parse(response.body)
  
        expect(comment.class).to eq(Hash)

        expected_hash = {
          "article_id" => @article.id,
          "author_name" => @valid_attrs[:author_name],
          "body" => @valid_attrs[:body],
          "id" => Comment.last.id,
        }

        expect(comment).to eq(expected_hash)
      end
    end
  end

  describe "DELETE #destroy" do
    describe 'with a valid ID' do
      before(:each) do
        article = create(:article)
        comment = create(:comment, article: article)

        delete "/api/v1/articles/#{article.id}/comments/#{comment.id}"
      end

      it "returns 204 (no content)" do
        expect(response).to have_http_status(204)
        expect(response.body).to eq('')
      end
    end

    describe 'with an invalid comment ID' do
      before(:each) do
        @article = create(:article)
        comment = create(:comment, article: @article)
        @comment_id_visited = comment.id + 1

        delete "/api/v1/articles/#{@article.id}/comments/#{@comment_id_visited}"
      end

      it "returns 404" do
        expect(response).to have_http_status(404)
      end

      it "returns an error" do
        body = JSON.parse(response.body)

        expect(body).to eq(
          {"error" => "No comment with ID #{@comment_id_visited} for article with ID #{@article.id}"}
        )
      end
    end

    describe 'with an invalid article ID' do
      before(:each) do
        @other_article = create(:article)
        article = create(:article)
        @comment = create(:comment, article: article)

        delete "/api/v1/articles/#{@other_article.id}/comments/#{@comment.id}"
      end

      it "returns 404" do
        expect(response).to have_http_status(404)
      end

      it "returns an error" do
        body = JSON.parse(response.body)

        expect(body).to eq(
          {"error" => "No comment with ID #{@comment.id} for article with ID #{@other_article.id}"}
        )
      end
    end
  end

  describe "PATCH #update" do
    describe 'with valid attributes' do
      before(:each) do
        @article = create(:article)
        @comment = create(:comment, article: @article)

        @valid_attrs = { body: Faker::Movies::StarWars.quote }

        patch "/api/v1/articles/#{@article.id}/comments/#{@comment.id}", params: { comment: @valid_attrs }
      end
  
      it "returns 200" do
        expect(response).to have_http_status(200)
      end
  
      it "outputs data for the updated comment" do
        comment = JSON.parse(response.body)
  
        expect(comment.class).to eq(Hash)
  
        expected_hash = {
          "article_id" => @article.id,
          "author_name" => @comment.author_name,
          "body" => @valid_attrs[:body],
          "id" => @comment.id,
        }

        expect(comment).to eq(expected_hash)
      end
    end
  end
end
