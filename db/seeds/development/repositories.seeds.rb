after :'development:organizations' do
  Repository
    .create_with(
      name: 'Sandbox',
      public: true
    )
    .find_or_create_by(
      organization: Organization.find_by(name: 'LearningTapestry')
    )
end
