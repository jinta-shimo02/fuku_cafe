Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: 'static_pages#top'
  get 'terms', to: 'static_pages#terms'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  resource :my_page, only: %i[show edit update]
  get 'home', to: 'maps#home'
  match 'search', to: 'maps#search', via: [:get]
end
