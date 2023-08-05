class PostsController < ApplicationController
    before_action :authenticate_user!, only: [:create, :update, :edit, :destroy]
    def allpost
        if params[:search].present?
            # Perform search based on query parameters
            @posts = Post.where("title LIKE ? OR topic LIKE ? OR author_id IN (SELECT id FROM users WHERE username LIKE ?)", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
        else
            # Show all posts
            @posts = Post.all
        end
        render json: @posts
        #render json: Post.all
        # @posts = Post.all
    end
    
    # fetch top post
    def top_posts
        @top_posts = Post.top_posts
        render json: @top_posts
    end
    
    # all unique topic list
    def topic_list
        topics = Post.distinct.pluck(:topic)
        render json: topics
      end

    # Filter by author
    def filter_by_author
        author_id = params[:author_id]
        @posts = Post.where(author_id: author_id)
        render json: @posts
    end

    # Filter by date
    def filter_by_date
        date = params[:date]
        @posts = Post.where("created_at >= ?", date)
        render json: @posts
    end

    # Filter by number of likes
    def filter_by_likes
        min_likes = params[:min_likes]
        @posts = Post.where("likes_count >= ?", min_likes)
        render json: @posts
    end

    # Filter by number of comments
    def filter_by_comments
        min_comments = params[:min_comments]
        @posts = Post.where("comments_count >= ?", min_comments)
        render json: @posts
    end
    # Create a new post
    def create
        @post =  current_user.posts.build(post_params) #Post.new(post_params)
        if @post.save
            render json: @post, status: :created
        else
            render json: @post.errors, status: :unprocessable_entity
        end
    end

    # Update a post
    def update
        @post = Post.find(params[:id])
        authorize_user(@post) # Custom method to check if the current user is the author
        if @post.update(post_params)
            return  {message: "successfully updated"}
        else
            return "error 401"
        end
    end

    # Edit a post
    def edit
        @post = Post.find(params[:id])
        authorize_user(@post) # Custom method to check if the current user is the author
    end

    # Delete a post
    def destroy
        @post = Post.find(params[:id])
        authorize_user(@post) # Custom method to check if the current user is the author
        @post.destroy
        head :no_content
    end

    private

    def authorize_user(post)
        unless current_user && current_user.id == post.author_id
          render json: { error: 'You are not authorized to perform this action.' }, status: :unauthorized
        end
    end
      
    # Strong parameters to whitelist the allowed parameters for the new post
    def post_params
        params.require(:post).permit(:title, :topic, :description, :featured_image)#.merge(author_id: current_user.id)
    end

end
