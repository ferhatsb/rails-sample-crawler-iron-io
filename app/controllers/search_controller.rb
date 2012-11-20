class SearchController < ApplicationController  
  def search
    
    query = params[:query]
    
    @pages = Tire.search 'pages' do
          query do
            string query
          end
        end
  end
end
