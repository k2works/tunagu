class Aiiiiiin < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  
  set :public_folder => "public", :static => true

  get "/" do
    erb :welcome
  end
end
