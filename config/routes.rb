Rails.application.routes.draw do
  resources :city_measures, only: [:index]
  resources :measure_correlations, only: [:index]
  root to: 'city_measures#index'
end
