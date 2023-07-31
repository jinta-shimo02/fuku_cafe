Rails.application.routes.draw do
  devise_for :users
  root to: 'static_pages#top'
  get 'terms', to: 'static_pages#terms'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  resource :my_page, only: %i[show edit update]
end
