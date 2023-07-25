Rails.application.routes.draw do
  root to: 'static_pages#top'
  get 'terms', to: 'static_pages#terms'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
end
