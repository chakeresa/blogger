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
        @valid_attrs = {
          title: Faker::Dessert.flavor,
          body: Faker::Lorem.paragraph(
            sentence_count: 3,
            supplemental: true,
            random_sentences_to_add: 3
          )
        }

        post "/api/v1/comments", params: { comment: @valid_attrs }
      end
  
      xit "returns 201" do
        expect(response).to have_http_status(201)
      end
  
      xit "outputs data for the new comment" do
        comment = JSON.parse(response.body)
  
        expect(comment.class).to eq(Hash)
  
        expect(comment["title"]).to eq(@valid_attrs[:title])
        expect(comment["body"]).to eq(@valid_attrs[:body])
        expect(comment["id"]).to eq(Comment.last.id)
      end
    end

    describe 'with invalid attributes' do
      before(:each) do
        @invalid_attrs = {
          title: Faker::Dessert.flavor
          # no body given
        }

        post "/api/v1/comments", params: { comment: @invalid_attrs }
      end
  
      xit "returns 422" do
        expect(response).to have_http_status(422)
      end
  
      xit "lists errors" do
        json = JSON.parse(response.body)
  
        expect(json.class).to eq(Hash)
  
        expect(json["errors"]).to eq({ "body" => ["can't be blank"] })
      end
    end
  end

  describe "DELETE #destroy" do
    describe 'with a valid ID' do
      before(:each) do
        @comment = create(:comment)
        delete "/api/v1/comments/#{@comment.id}"
      end

      xit "returns 204 (no content)" do
        expect(response).to have_http_status(204)
        expect(response.body).to eq('')
      end
    end

    describe 'with an invalid ID' do
      before(:each) do
        comment = create(:comment)
        @id = comment.id + 1
        delete "/api/v1/comments/#{@id}"
      end

      xit "returns 404" do
        expect(response).to have_http_status(404)
      end

      xit "returns an error" do
        body = JSON.parse(response.body)

        expect(body).to eq(
          {"error" => "No comment with ID #{@id}"}
        )
      end
    end
  end

  describe "PATCH #update" do
    describe 'with valid attributes' do
      before(:each) do
        @comment = create(:comment)
        @valid_attrs = { title: Faker::Dessert.flavor }

        patch "/api/v1/comments/#{@comment.id}", params: { comment: @valid_attrs }
      end
  
      xit "returns 200" do
        expect(response).to have_http_status(200)
      end
  
      xit "outputs data for the updated comment" do
        comment = JSON.parse(response.body)
  
        expect(comment.class).to eq(Hash)
  
        expected_hash = {
          "title" => @valid_attrs[:title],
          "body" => @comment.body,
          "id" => @comment.id
        }

        expect(comment).to eq(expected_hash)
      end
    end

    describe 'with invalid attributes' do
      before(:each) do
        @comment = create(:comment)
        @invalid_attrs = { title: nil }

        patch "/api/v1/comments/#{@comment.id}", params: { comment: @invalid_attrs }
      end
  
      xit "returns 422" do
        expect(response).to have_http_status(422)
      end
  
      xit "lists errors" do
        json = JSON.parse(response.body)
  
        expect(json.class).to eq(Hash)
  
        expect(json["errors"]).to eq({ "title" => ["can't be blank"] })
      end
    end
  end
end
