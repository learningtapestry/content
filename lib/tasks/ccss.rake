namespace :ccss do
  desc 'Load CCSS standards'
  task :load => :environment do
    CcssTasks.load
  end
end
