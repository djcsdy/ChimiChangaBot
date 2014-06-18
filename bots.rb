#!/usr/bin/env ruby

require 'twitter_ebooks'
require 'parseconfig'

config_file_name = "bots.conf"

unless File.exist? config_file_name then
  config_file = File.open(config_file_name, "w")
  config_file.write <<-END.gsub(/^[ \t]*/, "")
    [NotAllBot]

    # These details come from registering an app at https://dev.twitter.com/

    # Your app consumer key
    #consumer_key = ""

    # Your app consumer secret
    #consumer_secret = ""

    # Token connecting the app to this account
    #oauth_token = ""

    # Secret connecting the app to this account
    #oauth_secret = ""
  END
  config_file.close

  $stderr.puts "Created a new configuration file " << config_file_name << "."
  $stderr.puts "Edit " << config_file_name << " and try again."
  exit 1
end

begin
  config = ParseConfig.new(config_file_name)
rescue
  $stderr.puts "Invalid configuration file " << config_file_name << "."
  $stderr.puts "Edit " << config_file_name << " and try again."
  exit 2
end


Ebooks::Bot.new("NotAllBot") do |bot|
  bot.consumer_key = config["NotAllBot"]["consumer_key"]
  bot.consumer_secret = config["NotAllBot"]["consumer_secret"]
  bot.oauth_token = config["NotAllBot"]["oauth_token"]
  bot.oauth_token_secret = config["NotAllBot"]["oauth_token_secret"]
  
  raise "Invalid consumer_key" unless bot.consumer_key
  raise "Invalid consumer_secret" unless bot.consumer_secret
  raise "Invalid oauth_token" unless bot.oauth_token
  raise "Invalid oauth_token_secret" unless bot.oauth_token_secret

  bot.on_follow do |user|
    # Follow a user back
    # bot.follow(user[:screen_name])
  end

  bot.on_mention do |tweet, meta|
    # Reply to a mention
    # bot.reply(tweet, meta[:reply_prefix] + "oh hullo")
  end

  bot.on_timeline do |tweet, meta|
    # Reply to a tweet in the bot's timeline
    # bot.reply(tweet, meta[:reply_prefix] + "nice tweet")
  end

  bot.scheduler.every '24h' do
    # Tweet something every 24 hours
    # See https://github.com/jmettraux/rufus-scheduler
    # bot.tweet("hi")
  end
end
