Rails::TestTask.new('api' => 'test:prepare') do |t|
  t.pattern = "test/api/**/*_test.rb"
end
