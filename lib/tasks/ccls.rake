namespace :ccls do
  desc 'Load CCLS standards'
  task :load => :environment do
    CclsTasks.load
  end
end
