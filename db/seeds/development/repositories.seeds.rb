after :'development:organizations' do
  Repository
    .create_with(
      name: 'Sandbox',
      public: true
    )
    .find_or_create_by(
      value: 'sandbox',
      organization: Organization.find_by(value: :lt)
    )
end
