require 'sidekiq/api'

module SidekiqTasks
  extend self

  def clear_queue
    Sidekiq::Queue.new.clear
    Sidekiq::RetrySet.new.clear
  end
end
