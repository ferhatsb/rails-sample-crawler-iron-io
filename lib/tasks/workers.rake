namespace :workers do
  desc 'uploads crawler and indexer workers to Iron.oi'
  task :upload do
    Rake::Task['iron_worker upload'].invoke('workers/WebCrawler')
    Rake::Task['iron_worker upload'].invoke('workers/PageProcessor')
    Rake::Task['iron_worker upload'].invoke('workers/Indexer')
    desc 'uploading workers are completed'
  end
end