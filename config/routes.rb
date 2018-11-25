Rails.application.routes.draw do
  get 'projects/:project_name/map', to: 'projects#map'
  get 'projects/:project_name/analytics', to: 'projects#analytics'
  get 'projects/:project_name/image', to: 'projects#image'
  get 'disasters/index'
  get 'static/map'
  get 'static/check'
  get 'static/hearing'
  get 'position/index'
  post 'position/create'
  get 'divide/', to: 'divide#index'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
