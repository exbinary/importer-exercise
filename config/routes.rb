Importer::Application.routes.draw do
  devise_for :users
  resources :imports, only: [:index, :new, :create, :show]
  get '/:page'  => 'static_pages#show', as: 'page'
  root 'static_pages#home'
end
