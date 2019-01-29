require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Grimoire
  class Application < Rails::Application
    VERSION = 0.5

    config.eager_load_paths += Dir["#{config.root}/lib/"]

    # cache
    config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }

    # i18n
    config.i18n.default_locale = :ru
    config.i18n.available_locales = [:ru, :en]
    config.i18n.fallbacks = [:en]

    # rack cors
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => :any
      end
    end

    # assets paths
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

    config.react.server_renderer_options = {
      :files => %w(web/server_rendering.js)
    }

    # other settings
    config.x.api_key = 'master_key'
    config.x.report_to = []
    config.x.bungie_api_key = ''
    config.x.twitter_consumer_key = ''
    config.x.twitter_consumer_secret = ''
    config.x.twitter_access_token = ''
    config.x.twitter_access_token_secret = ''
    config.x.twitter_username = 'BungieHelp_ru'
  end
end
