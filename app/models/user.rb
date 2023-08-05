class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # attr_accessor :email, :password, :password_confirmation, :remember_me, :username

  has_many :likes
  has_many :comments
  has_many :views
  has_many :follows_as_follower, class_name: 'Follow', foreign_key: 'follower_id'
  has_many :follows_as_followed, class_name: 'Follow', foreign_key: 'followed_id'
  has_many :following, through: :follows_as_follower, source: :followed
  has_many :followers, through: :follows_as_followed, source: :follower

  has_many :posts, foreign_key: 'author_id'
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def similar_authors
    author_ids = Post.where(topic: posts.pluck(:topic)).pluck(:author_id).uniq
    User.where(id: author_ids).where.not(id: id)
  end

end
