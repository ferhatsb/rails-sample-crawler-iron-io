class CrawlerController < ApplicationController
  
  def index
  end
  
  def crawl
  
    p = {'url' => params[:url],
       'page_limit' => 10000,
       'depth' => 10,
       'max_workers' => 50,
       'iron_cache_id' => ENV['IRON_CACHE_PROJECT_ID'],
       'iron_cache_token' => ENV['IRON_CACHE_TOKEN'],
       'iron_mq_project_id' => ENV['IRON_MQ_PROJECT_ID'],
       'iron_mq_token' => ENV['IRON_MQ_TOKEN'],
       'iron_worker_project_id' => ENV['IRON_WORKER_PROJECT_ID'],
       'iron_worker_token' => ENV['IRON_WORKER_TOKEN'],
       'searchbox_url' => ENV['SEARCHBOX_URL']}
       
    puts p['url']
    
    ng_client = IronWorkerNG::Client.new(:token => p['iron_worker_token'], :project_id => p['iron_worker_project_id'])
    #cleaning up cache
    cache = IronCache::Client.new(:token => p['iron_cache_token'], :project_id => p['iron_cache_id'])
    cache.items.put('pages_count', 0)
    #launching worker
    puts "Launching crawler"
    ng_client.tasks.create("WebCrawler", p)
    
    render action: "index"
    
  end
end
