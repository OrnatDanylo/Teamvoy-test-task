Rails.application.routes.draw do
  root 'search#index'

  get 'search/new' => 'search#new'
end
