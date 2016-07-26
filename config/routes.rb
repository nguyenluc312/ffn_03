Rails.application.routes.draw do
  devise_for :users, skip: :sessions,
   controllers: {omniauth_callbacks: "omniauth_callbacks"}
  as :user do
    get "login" => "devise/sessions#new", as: :new_user_session
    post "login" => "devise/sessions#create", as: :user_session
    delete "logout" => "devise/sessions#destroy", as: :destroy_user_session
  end

  mount Ckeditor::Engine => "/ckeditor"
  root "static_pages#home"
  get "help" => "static_pages#help"
  get "contact" => "static_pages#contact"

  namespace :admin do
    root "countries#new"
    resources :countries, only: [:index, :new, :create]
    resources :leagues, except: [:edit, :update] do
      resources :league_seasons, except: :destroy
    end
    resources :league_seasons, except: :destroy do
      resources :matches, except: [:index, :destroy]
    end
    resources :news, except: :show
    resources :news_types, except: :show
    resources :teams, except: :show do
      resource :assign_players, only: :show
    end
    resources :matches, only: [:edit, :update] do
      resources :match_events, only: :create
    end
    resources :users, only: [:index, :update, :destroy]
    resources :players, except: :show do
      resource :assign_players, only: [:create, :update, :destroy]
    end
  end

  resources :news, only: :show do
    member do
      resources :comments, only: :create
    end
  end

  resources :matches, only: :show
  resources :teams, only: [:index, :show]
  resources :comments, except: [:index, :show]
  resources :user_bets, only: [:create, :index]
  resources :leagues, only: :index
  resources :league_seasons, only: :show
  resources :players, only: [:index, :show]
  resources :teams, only: [:index, :show]
  resources :users, only: :show
  resources :countries, only: :index
end
