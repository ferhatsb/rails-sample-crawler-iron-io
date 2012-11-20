namespace :workers do
  task :upload do
    desc 'uploads crawler and indexer workers to Iron.oi'
    Rake::Task['iron_worker upload'].invoke('workers/WebCrawler')
    Rake::Task['iron_worker upload'].invoke('workers/PageProcessor')
    Rake::Task['iron_worker upload'].invoke('workers/Indexer')
    desc 'uploading workers are completed'
  end
end