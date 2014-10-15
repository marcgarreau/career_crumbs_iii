Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  root to: 'pages#welcome'

  get 'suggestions'    , to: 'pages#suggestions'    , as: 'suggestions'
  get 'intro', to: 'pages#intro', as: 'intro'

  get 'dashboard', to: 'dashboards#show',   as: 'dashboard'
  get 'graph',     to: 'user_graphs#show',  as: 'graph'
  get 'meetups',   to: 'user_meetups#show', as: 'meetups'

  resources :bookmarks, only: [:create, :destroy]

  devise_scope :user do
    get 'login',      to: 'omniauth_callbacks#authorize',      as: 'login'
    get 'my_profile', to: 'omniauth_callbacks#my_profile', as: 'my_profile'
    get 'accept',     to: 'omniauth_callbacks#accept',     as: 'accept'
    get 'profile',    to: 'omniauth_callbacks#profile',    as: 'profile'
  end
end
