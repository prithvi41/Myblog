class Post < ApplicationRecord
    has_one_attached :featured_image
    has_many :likes
    has_many :comments
    has_many :views
    belongs_to :author, class_name: 'User', foreign_key: 'author_id'
    
    # top post
    def self.top_posts
        order(Arel.sql("COALESCE(likes_count, 0) * 2 + COALESCE(comments_count, 0) DESC"))
    end
    
    # recommended post
    def self.recommended_posts(user)
        liked_topics = user.likes.joins(:post).pluck('posts.topic').uniq
        where(topic: liked_topics).where.not(id: user.likes.pluck(:post_id))
    end

    def accessible?(user)
        if user.subscribed? || user.available_views.positive?
          increment_views(user)
          true
        else
          false
        end
    end

    private
    def increment_views(user)
      update(views_count: views_count + 1)
      user.update(available_views: user.available_views - 1) unless user.subscribed?
    end
end
