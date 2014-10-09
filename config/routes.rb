Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  root to: 'pages#welcome'

  get 'i', to: 'pages#i', as: 'i'

  get 'dashboard', to: 'dashboards#show', as: 'dashboard'
  get 'graph', to: 'user_graphs#show', as: 'graph'
  get 'meetups', to: 'user_meetups#show', as: 'meetups'

  devise_scope :user do
    get 'login',      to: 'omniauth_callbacks#index',      as: 'login'
    get 'my_profile', to: 'omniauth_callbacks#my_profile', as: 'my_profile'
    get 'accept',     to: 'omniauth_callbacks#accept',     as: 'accept'
    get 'profile',    to: 'omniauth_callbacks#profile',    as: 'profile'
  end
end
