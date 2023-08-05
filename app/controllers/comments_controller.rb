class CommentsController < ApplicationController
    before_action :authenticate_user!

    def create
        @post = Post.find(params[:post_id])
        @comment = current_user.comments.build(post: @post, comment_text: params[:comment_text])
  
        if @comment.save
            @post.increment!(:comments_count)
            render json: { message: "Comment created successfully." }
        else
            render json: { error: "Unable to create the comment." }, status: :unprocessable_entity
        end
    end
    def destroy
        @comment = current_user.comments.find_by(post_id: params[:post_id], id: params[:id])
    
        if @comment
            @comment.destroy
            @post.decrement!(:comments_count)
            render json: { message: "Comment deleted successfully." }
        else
            render json: { error: "You don't have permission to delete this comment." }, status: :unprocessable_entity
        end
    end
end
