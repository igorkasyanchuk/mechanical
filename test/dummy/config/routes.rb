Rails.application.routes.draw do
  root 'welcome#index'
  post '/submit_user' => 'welcome#submit_user'
  post '/submit_post' => 'welcome#submit_post'
  mount Mechanical::Engine => "/mechanical"
end
