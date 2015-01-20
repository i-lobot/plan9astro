require 'twitter_ebooks'
require 'yaml'
require './astro_logic.rb'


# This is an example bot definition with event handlers commented out
# You can define and instantiate as many bots as you like

class MyBot < Ebooks::Bot
  # Configuration here applies to all MyBots
  def configure
    # Consumer details come from registering an app at https://dev.twitter.com/
    # Once you have consumer details, use "ebooks auth" for new access tokens
    config = YAML.load_file('secrets.yml')
    self.consumer_key = config['consumer_key']
    self.consumer_secret = config['consumer_secret']


    # Users to block instead of interacting with
    self.blacklist = ['tnietzschequote']

    # Range in seconds to randomize delay when bot.delay is called
    self.delay_range = 1..6
  end

  def on_startup
    @logic = AstroLogic.new
    generate()
    scheduler.every '24h' do
      # Tweet something every 24 hours
      # See https://github.com/jmettraux/rufus-scheduler
      # tweet("hi")
      # pictweet("hi", "cuteselfie.jpg")
      generate()
    end
  end

  def generate()
    @logic.generate.each do |pair|
      time,string = pair
      log "#{time}: #{string}"
      scheduler.at time do
        tweet(string)
      end
    end
  end

  def on_message(dm)
    # Reply to a DM
    # reply(dm, "secret secrets")
  end

  def on_follow(user)
    # Follow a user back
    # follow(user.screen_name)
  end

  def on_mention(tweet)
    # Reply to a mention
    # reply(tweet, "oh hullo")
  end

  def on_timeline(tweet)
    # Reply to a tweet in the bot's timeline
    # reply(tweet, "nice tweet")
  end
end

# Make a MyBot and attach it to an account
MyBot.new("plan9astro") do |bot|
  config = YAML.load_file('secrets.yml')
  bot.access_token = config['access_token']
  bot.access_token_secret = config['access_token_secret']
end
