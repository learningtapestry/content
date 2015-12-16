after :'development:organizations' do
  lt_admin = User
    .create_with(password: 'admin123')
    .find_or_create_by!(email: 'admin@learningtapestry.com')

  lt_admin.add_role(:admin, Organization.find_by(name: 'LearningTapestry'))
end
