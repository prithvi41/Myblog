class UsersController < ApplicationController
    before_action :authenticate_user! #only: [:show, :my_posts]

    def show
      @user = User.find(params[:id])
      render json: @user
    end

    def my_posts
        @user = current_user
        @my_posts = @user.posts.includes(:likes)
        render json: @my_posts
    end

    def recommended_posts
        user = User.find(params[:id])
        recommended_posts = Post.recommended_posts(user)
        render json: recommended_posts
    end

    def similar_authors_posts
        user = User.find(params[:id])
        similar_authors = user.similar_authors
        similar_authors_posts = Post.where(author_id: similar_authors).order(created_at: :desc)
        render json: similar_authors_posts
    end

end
