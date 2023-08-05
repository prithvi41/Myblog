Rails.application.routes.draw do
  devise_for :users
  # resources :posts, only: [:create]
  resources :posts do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
    collection do
      get 'filter_by_author'
      get 'filter_by_date'
      get 'filter_by_likes'
      get 'filter_by_comments'
    end
    collection do
      get 'top_posts'
    end
    collection do
      get 'topic_list'
    end
    # member do
    #   # patch 'edit', to: 'posts#update'
    #   delete 'delete', to: 'posts#destroy'
    # end
  end
  # resources :users, only: [:show]
  resources :users, only: [:show] do
    get 'my_posts', on: :member
    get 'recommended_posts', on: :member
    get 'similar_authors_posts', on: :member
    member do
      # ...
      post 'follow', to: 'follows#create'   # Follow action
      delete 'unfollow', to: 'follows#destroy' # Unfollow action
    end
  end
  post 'posts', to: 'posts#create'
  get 'allpost', to: 'posts#allpost'
  resources :payments, only: [:create, :webhook]


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html



  # Defines the root path route ("/")
  # root "articles#index"
end
