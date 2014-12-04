# Load path and gems/bundler
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require "bundler"
Bundler.require

# Local config
require "find"

%w{config/initializers lib}.each do |load_path|
  Find.find(load_path) { |f|
    require f unless f.match(/\/\..+$/) || File.directory?(f)
  }
end

# database config
use ActiveRecord::ConnectionAdapters::ConnectionManagement

# Load app
require "aiiiiiin"
#run Aiiiiiin

run Rack::URLMap.new \
"/"       => Aiiiiiin.new,
"/split" => Split::Dashboard.new