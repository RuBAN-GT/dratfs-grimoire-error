class RailsClient < BungieClient::Client
  attr_reader :ttl
  attr_reader :prefix

  def initialize(options = {})
    options[:api_key] = Rails.configuration.x.bungie_api_key if options[:api_key].nil?

    super

    @ttl    = (options[:ttl].is_a?(Integer) && options[:ttl] > 60.seconds) ? options[:ttl] : 15.minutes
    @prefix = (options[:prefix].is_a? String) ? options[:prefix] : 'default'
  end

  def get(uri, parameters = {})
    parameters = {} if parameters.nil?

    ttl    = (parameters[:ttl].is_a?(Integer) && parameters[:ttl] > 60.seconds) ? parameters[:ttl] : @ttl
    prefix = parameters[:prefix]
    cached = !(parameters[:cached] === false)

    parameters.delete :ttl
    parameters.delete :prefix
    parameters.delete :cached

    key   = cache_key uri, parameters, prefix
    entry = (cached) ? Rails.cache.read(key) : nil

    if entry.nil?
      entry = super uri, parameters

      Rails.cache.write key, entry, :expires_in => ttl || @ttl
    end

    entry
  end

  # Get cache key for `get` method
  def cache_key(uri, params = {}, extra = '')
    "#{@prefix}#{extra}/#{uri}/#{Marshal.dump params}"
  end

  # Remove entry from cache
  def flush(key)
    Rails.cache.delete key
  end
end
