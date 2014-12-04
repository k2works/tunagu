require "sinatra/activerecord/rake"
require "./config/initializers/database"
require "./aiiiiiin"

%w{ bundler find rake/testtask}.each { |lib| require lib }

task :default => :spec

Rake::TestTask.new(:spec) do |t|
  t.test_files = FileList['spec/*_spec.rb']
end
