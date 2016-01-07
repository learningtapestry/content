after :'development:organizations' do
  ApiKey.find_or_create_by(
    key: '0594aed5-e320-4344-9b73-7d7fab0bff3f',
    organization: Organization.find_by(name: 'LearningTapestry')
  )
end
