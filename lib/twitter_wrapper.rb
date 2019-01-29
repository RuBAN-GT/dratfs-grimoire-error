class TwitterWrapper
  attr_reader :consumer_key, :consumer_secret, :access_token, :access_token_secret, :username

  def initialize(options = {})
    @consumer_key = options[:consume_key] || Rails.configuration.x.twitter_consumer_key

    @consumer_secret = options[:consumer_secret] || Rails.configuration.x.twitter_consumer_secret

    @access_token = options[:access_token] || Rails.configuration.x.twitter_access_token

    @access_token_secret = options[:access_token_secret] || Rails.configuration.x.twitter_access_token_secret

    @username = options[:username] || Rails.configuration.x.twitter_username
  end

  def client
    return @client unless @client.nil?

    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = consumer_key
      config.consumer_secret     = consumer_secret
      config.access_token        = access_token
      config.access_token_secret = access_token_secret
    end
  end

  def get_tweets(count = 10)
    cache = Rails.cache.read "tweets.#{username}.#{count}"

    return cache unless cache.nil?

    tweets = client.user_timeline username,
      :count => count,
      :exclude_replies => true

    tweets.map! do |tweet|
      Hashie::Mash.new({
        :id => tweet.id,
        :created_at => tweet.created_at.strftime('%d.%m.%y'),
        :text => tweet.full_text,
        :url => tweet.url.to_s
      })
    end
    Rails.cache.write "tweets.#{username}.#{count}", tweets, :expires_in => 1.hour

    tweets
  end
end
