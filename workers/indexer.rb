require 'json'
require 'tire'
require 'iron_mq'
require 'open-uri'
require 'digest/sha1'


def get_list_of_messages
  #1000 pages per worker at max
  max_number_of_pages = 1000
  puts "Getting messages from IronMQ"
  @queue = @iron_mq_client.queue("index_queue")
  messages = @queue.get(:n => max_number_of_pages, :timeout => 100)
  puts "Got messages from queue - #{messages.count}"
  messages
end

def index_pages(messages)
  #using elasticsearch bulk api
  pages = []
  #processing each pages
  messages.each do |message|
    page = JSON message.body
    pages << {:id => Digest::SHA1.hexdigest(page['url']), :type => 'page', :url => page['url'], :content => page['content']}.to_json
    message.delete
  end
  Tire.index 'pages' do
    # create index if it does not exists
    create
    import pages
  end
end

#configure Tire with SearchBox.io
puts "Configuring tire with #{params['searchbox_url']}"
Tire::Configuration.url params['searchbox_url']

#initializing Iron MQ
@iron_mq_client = IronMQ::Client.new(:token => params['iron_mq_token'], :project_id => params['iron_mq_project_id'])

#getting list of pages
messages = get_list_of_messages

# index all pages
index_pages(messages)