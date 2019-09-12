Rails.application.routes.draw do
  root 'welcome#index'
  post '/submit' => 'welcome#submit'
  mount Mechanical::Engine => "/mechanical"
end
