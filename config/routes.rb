Rails.application.routes.draw do
  root :to => 'pages#home'
  
  resources :users, :except => [:destroy]
  get '/signup_login' => 'users#signup_login'
  
  resources :challenges do
    get '/accept' => 'challenges#accept'
    resources :pledges, :only => [:new, :create, :index]
  end

  get '/my_challenges' => 'challenges#my_index'

  get '/login' => 'session#new'
  post '/login' => 'session#create'
  delete '/login' => 'session#destroy'
end
