namespace :sidekiq do
  task clear: :environment do
    SidekiqTasks.clear_queue
  end
end
