Importer::Application.routes.draw do
  devise_for :users

  root 'static_pages#home'

  get '/:page'  => 'static_pages#show', as: 'page'
end
