require 'yajl/json_gem'
require 'tire'
require 'iron_mq'
require 'open-uri'
require 'digest/sha1'


def get_list_of_messages
  #100 pages per worker at max
  max_number_of_pages = 100
  puts "Getting messages from IronMQ"
  @queue = @iron_mq_client.queue("index_queue")
  messages = @queue.get(:n => max_number_of_urls, :timeout => 100)
  puts "Got messages from queue - #{messages.count}"
  messages
end

def index_pages(messages)
  #parser
  parser = Yajl::Parser.new
  #using elasticsearch bulk api
  pages = []
  #processing each pages
  messages.each do |message|
    page = parser.parse(message.body)
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
Tire.configure do
  url p['searchbox_url']
end

#initializing Iron MQ
@iron_mq_client = IronMQ::Client.new(:token => p['iw_token'], :project_id => p['iw_project_id'])

#getting list of pages
messages = get_list_of_messages

# index all pages
index_pages(messages)