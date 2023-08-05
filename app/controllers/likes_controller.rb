class LikesController < ApplicationController
    before_action :authenticate_user!

    def create
        @post = Post.find(params[:post_id])
        @like = current_user.likes.build(post: @post)
  
        if @like.save
            @post.increment!(:likes_count)
            render json: { message: "Post liked successfully." }
        else
            render json: { error: "Unable to like the post." }, status: :unprocessable_entity
        end
    end
    def destroy
        @post = Post.find(params[:post_id])
        @like = current_user.likes.find_by(post_id: params[:post_id])
    
        if @like
            @like.destroy
            @post.decrement!(:likes_count)
            render json: { message: "Post unliked successfully." }
        else
            render json: { error: "You have not liked this post." }, status: :unprocessable_entity
        end
    end
end
