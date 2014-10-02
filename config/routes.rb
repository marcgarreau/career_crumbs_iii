Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  root to: 'pages#welcome'

  get 'profile', to: 'pages#profile', as: 'profile'
  devise_scope :user do
    get 'my_profile', to: 'omniauth_callbacks#my_profile', as: 'my_profile'
    get 'accept', to: 'omniauth_callbacks#accept', as: 'accept'
  end
end
