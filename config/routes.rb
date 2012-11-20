RailsSample::Application.routes.draw do

  resources :documents, :except => :show do
    collection do
      get 'search'
      get 'bulk_index'
    end
  end

  get 'about', :to => 'home#about'
  root :to => 'home#index'
  
  get 'crawler', :to => 'crawler#index'

end
