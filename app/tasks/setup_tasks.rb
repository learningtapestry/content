require 'highline'

module SetupTasks
  extend self

  def setup_organization
    cli = HighLine.new

    puts 'Creating organization.'
    name = cli.ask 'Organization name: '
    org = Organization.new(name: name)
    org.create_api_key
    org.save!
    puts "Organization #{org.name} created."
    puts "An API key was generated: #{org.api_keys.first.key}"
    puts

    puts 'Adding admin user to organization.'
    email = cli.ask 'User e-mail: '
    pwd = cli.ask('User password: ') { |q| q.echo = false }
    user = User.new(email: email, password: pwd)
    user.add_role(:admin, org)
    user.save!
    puts "Admin #{user.email} created."
    puts

    puts 'Creating a repository.'
    name = cli.ask 'Repository name: '
    is_public = cli.ask("Is repository public (y/n)? ") { |q| q.validate = /^[yn]$/ }
    is_public = is_public == 'y' ? true : false
    Repository.create!(name: name, public: is_public, organization: org)
    puts 'Repository created.'
    puts 'Bye.'
  end
end
