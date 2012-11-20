namespace :iron_worker do
  desc 'example'
    task :upload do
      Rake::Task['iron_worker upload workers/WebCrawler']
      Rake::Task['iron_worker upload workers/PageProcessor']
      Rake::Task['iron_worker upload workers/Indexer']
    end
end