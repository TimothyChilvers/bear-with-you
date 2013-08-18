require 'twitter'
require 'json'

Twitter.configure do |config|
  config.consumer_key = YOUR_CONSUMER_KEY
  config.consumer_secret = YOUR_CONSUMER_SECRET
  config.oauth_token = YOUR_OAUTH_TOKEN
  config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET
end

users_file_path = "stored_users.json"

if File.exist?(users_file_path)
  user_file = File.read(users_file_path)
  @previous_targets = JSON.parse(user_file)
else 
  @previous_targets = []  
end


while true
  Twitter.search("\"bear with me\"", :count => 20, :result_type => "recent").results.map do |status|
        
    if status.retweeted_status.nil?
      if !@previous_targets.include?("#{status.from_user}")
        @previous_targets << "#{status.from_user}"
        File.open(users_file_path, 'w') { |file| file.write(@previous_targets.to_json) }
        Twitter.update("@#{status.from_user} I'm with you",:in_reply_to_status_id => status.id)
        break
      end
    end
  end
  File.open(users_file_path, 'w') { |file| file.write(@previous_targets.to_json) }
  sleep 300
end