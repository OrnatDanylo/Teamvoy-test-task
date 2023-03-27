Rails.application.routes.draw do
  root 'search#index'

  get 'search' => 'search#new'
end
