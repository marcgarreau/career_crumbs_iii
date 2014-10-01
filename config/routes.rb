Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  root to: 'pages#welcome'

  get 'profile', to: 'pages#profile', as: 'profile'
  get 'my_profile', to: 'omniauth_callbacks', as: 'my_profile'

end
