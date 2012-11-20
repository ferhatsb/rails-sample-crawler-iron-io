class SearchController < ApplicationController  
  def search
    
    query = params[:query]
    
    @pages = Tire.search 'articles' do
          query do
            string query
          end
        end
  end
end
