# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %(app lib config test spec feature)

## Uncomment to clear the screen before every task
# clearing :on

guard 'livereload' do
  watch(%r{public/stylesheets/.+\.(css|s[ac]ss)$})
  watch(%r{public/javascripts/.+\.(js|coffee)$})
  watch(%r{views/.+\.(erb|haml|slim|s[ac]ss|coffee)$})
  watch(%r{.+\.(rb)$})
end

guard :shotgun, server: "thin", host: "0.0.0.0", port: "9292" do
end
