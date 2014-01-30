Importer::Application.routes.draw do
  root 'static_pages#home'

  get '/:page'  => 'static_pages#show', as: 'page'
end
