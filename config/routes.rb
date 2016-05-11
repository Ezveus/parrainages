Rails.application.routes.draw do
  resources :users, except: [:edit, :update] do
    get 'delete' => 'users#destroy', as: 'destroy'
  end

  get 'home' => 'static#home', as: :home

  root 'static#home'
end
