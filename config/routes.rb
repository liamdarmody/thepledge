Rails.application.routes.draw do
  root :to => 'pages#home'
  
  resources :users, :only => [:new, :create, :index]
  get '/signup_login' => 'users#signup_login'
  
  resources :challenges do
    resources :pledges, :only => [:new, :create, :index]
  end

  get '/login' => 'session#new'
  post '/login' => 'session#create'
  delete '/login' => 'session#destroy'
end
