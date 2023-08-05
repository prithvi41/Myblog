class FollowsController < ApplicationController
    before_action :authenticate_user!

    def create
        followed_user = User.find(params[:id])
        follow = current_user.follows_as_follower.build(followed: followed_user)
  
        if follow.save
            render json: { message: "You are now following #{followed_user.username}" }
        else
            render json: { error: "Unable to follow #{followed_user.username}" }, status: :unprocessable_entity
        end
    end

    def destroy
        follow = current_user.follows_as_follower.find_by(followed_id: params[:id])
    
        if follow
            follow.destroy
            render json: { message: "You have unfollowed #{follow.followed.username}" }
        else
            render json: { error: "You are not following this user" }, status: :unprocessable_entity
        end
    end
end
