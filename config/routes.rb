FarmBot::Application.routes.draw do

  namespace :api, defaults: {format: :json}, constraints: { format: 'json' } do
    resources :images,        only: [:create, :destroy, :show, :index]
    resources :regimens,      only: [:create, :destroy, :index, :update]
    resources :peripherals,   only: [:create, :destroy, :index, :update]
    resources :corpuses,      only: [:index, :show]
    resources :logs,          only: [:index, :create, :destroy]
    resources :sequences,     only: [:create, :update, :destroy, :index, :show]
    resources :farm_events,   only: [:create, :update, :destroy, :index]
    resources :tools,         only: [:create, :show, :index, :destroy, :update]
    resources :points,        only: [:create, :show, :index, :destroy, :update] do
        post :search, on: :collection
    end
    resource :public_key,     only: [:show]
    resource :tokens,         only: [:create]
    resource :users,          only: [:create, :update, :destroy, :show]
    resource :device,         only: [:show, :destroy, :create, :update]
    resource :webcam_feed,    only: [:show, :update]
    resources :password_resets, only: [:create, :update]
    put "/password_resets"     => "password_resets#update", as: :whatever
    put "/users/verify/:token" => "users#verify",           as: :users_verify
  # Make life easier on API users by not adding special rules for singular
  # resources. Otherwise methods like `save()` on the frontend would need to
  # keep track of an `isSingular` property, which I would prefer to not do.
  put   "/device/:id" => "devices#update", as: :put_device_redirect
  patch "/device/:id" => "devices#update", as: :patch_device_redirect
  put   "/users/:id"  => "users#update",   as: :put_users_redirect
  patch "/users/:id"  => "users#update",   as: :patch_users_redirect

  end

  devise_for :users

  # Generate a signed URL for Google Cloud Storage uploads.
  get "/api/storage_auth" => "api/images#storage_auth", as: :storage_auth
  # You can set FORCE_SSL when you're done.
  get "/.well-known/acme-challenge/:id" => "dashboard#lets_encrypt", as: :lets_encrypt

  # =======================================================================
  # NON-API (USER FACING) URLS:
  # =======================================================================
  get "/" => 'dashboard#front_page', as: :front_page
  get "/app" => 'dashboard#main_app', as: :dashboard
  match "/app/*path", to: 'dashboard#main_app', via: :all
  get "/password_reset/*token" => 'dashboard#password_reset',
    as: :password_reset
  get "/verify" => 'dashboard#verify', as: :verify
end
