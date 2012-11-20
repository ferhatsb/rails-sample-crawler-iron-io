class SearchController < ApplicationController  
  def search
    @pages = Tire.search 'articles' do
          query do
            string params[:query]
          end
        end
  end
end
