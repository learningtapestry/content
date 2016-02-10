namespace :es do
  desc 'Reset an index (caution: this will wipe out everything previously indexed)'
  task :reset_index, [:model] => :environment do |t, args|
    ESTasks.reset_index args[:model]
  end

  desc 'index all entries from the db for a given model'
  task :index_all, [:model] => :environment do |t, args|
    ESTasks.index_all args[:model]
  end
end
