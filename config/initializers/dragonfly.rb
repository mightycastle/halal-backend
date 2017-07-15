require 'dragonfly'

app = Dragonfly[:images]
app.configure_with(:imagemagick)
app.configure_with(:rails)
app.configure do |c|
  c.url_host = "http://#{CURRENT_HOST}"
end
app.define_macro(ActiveRecord::Base, :image_accessor)
