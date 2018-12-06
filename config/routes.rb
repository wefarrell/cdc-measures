Rails.application.routes.draw do
  resources :city_measures, only: [:index]
  resources :measure_correlations, only: [:index]
  resources :measure_labels, only: [:index]
  root to: 'city_measures#index'
end
