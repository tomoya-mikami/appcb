Rails.application.routes.draw do
  get 'disasters/index'
  get 'static/map'
  get 'static/check'
  get 'static/hearing'
  get 'position/index'
  post 'position/create'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
