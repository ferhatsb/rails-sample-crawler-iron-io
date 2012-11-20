require 'open-uri'
require 'nokogiri'
require 'iron_cache'
require 'iron_mq'

def process_page(url)
  puts "Processing page #{url}"
  doc = Nokogiri(open(url))

  #putting all in index queue
  @queue = @iron_mq_client.queue("index_queue")

  @queue.post({:status => "processed",
               :url => CGI::escape(url),
               :content => doc,
               :timestamp => Time.now}.to_json)
end

def get_list_of_messages
  #100 pages per worker at max
  max_number_of_urls = 100
  puts "Getting messages from IronMQ"
  @queue = @iron_mq_client.queue("page_queue")
  messages = @queue.get(:n => max_number_of_urls, :timeout => 100)
  puts "Got messages from queue - #{messages.count}"
  messages
end

def increment_counter(url, cache_item)
  puts "Page already processed, so bypassing it and incrementing counter"
  item = JSON.parse(cache_item)
  item["processed_counter"]+=1 if item["processed_counter"]
  @iron_cache_client.items.put(CGI::escape(url), item.to_json)
end

def queue_indexers
  @iron_worker_client.tasks.create("Indexer", params)
end

#initializing IW an Iron Cache
@iron_cache_client = IronCache::Client.new({"token" => params['iron_cache_token'], "project_id" => params['iron_cache_id']})
@iron_mq_client = IronMQ::Client.new(:token => params['iron_mq_token'], :project_id => params['iron_mq_project_id'])

#getting list of urls
messages = get_list_of_messages

#processing each url
messages.each do |message|
  url = CGI::unescape(message.body)
  #getting page details if page already processed
  cache_item = @iron_cache_client.items.get(CGI::escape(url))
  if cache_item
    process_page(url)
  else
    increment_counter(url, cache_item)
  end
  message.delete
end

#after sending all pages to queue, start indexer
queue_indexers


