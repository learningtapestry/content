namespace :sidekiq do
  task clear: :environment do
    require 'sidekiq/api'
    Sidekiq::Queue.new.clear
    Sidekiq::RetrySet.new.clear
  end
end
