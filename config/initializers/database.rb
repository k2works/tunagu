require "sinatra/activerecord"

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'sqlite3:aiiiiiin.db')
