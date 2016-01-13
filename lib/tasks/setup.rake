namespace :setup do
  task organization: :environment do
    SetupTasks.setup_organization
  end
end
