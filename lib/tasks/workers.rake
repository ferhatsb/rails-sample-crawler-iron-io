namespace :workers do
  task :upload do
    desc 'uploads crawler and indexer workers to Iron.oi'
    exec { run iron_worker upload workers/WebCrawler }
    exec { run iron_worker upload workers/PageProcessor exec }
    exec { run iron_worker upload workers/Indexer }
    desc 'uploading workers are completed'
  end
end