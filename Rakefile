require 'sinatra/activerecord/rake'

require_relative 'app.rb'

desc "Test Simple Message"
task :test_simple do
  # user id is mine
  MessageHandler.send_message(90530017, "This is a simple test message from Rakefile")
end

desc "Test Inline Keyboard Message"
task :test_inline_keyboard do
  # user id is mine
  MessageHandler.send_inline_keyboard(90530017, "This is an inline test message from Rakefile")
end

desc "Test Reply Keyboard Message"
task :test_reply_keyboard do
  # user id is mine
  MessageHandler.send_reply_keyboard(90530017, "This is an inline test message from Rakefile")
end

desc "Open Console"
task :console do
  binding.pry
end
