RailsSample::Application.routes.draw do
  
  get 'about', :to => 'home#about'
  root :to => 'home#index'
  
  get 'crawler', :to => 'crawler#index'
  get 'crawler/crawl', :to => 'crawler#crawl', :as => 'crawl'
  get 'search', :to => 'search#search'

end
