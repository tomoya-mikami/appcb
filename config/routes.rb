Rails.application.routes.draw do
  get 'static/map'
  get 'static/check'
  get 'static/hearing'
  get 'position/index'
  get 'position/create'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
