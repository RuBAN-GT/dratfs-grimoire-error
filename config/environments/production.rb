Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.react.variant = :production
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :sass
  config.assets.compile = false
  config.assets.digest = true
  config.action_controller.asset_host = nil

  config.action_cable.allowed_request_origins = [ 'https://grimoire.fydir.ru' ]
  config.force_ssl = true

  config.log_level = :warn
  config.log_tags = [ :request_id ]

  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.raise_delivery_errors = false

  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  config.active_support.deprecation = :notify

  config.log_formatter = ::Logger::Formatter.new
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_record.dump_schema_after_migration = false

  config.x.api_key = nil
  config.x.report_to = %w(darico3000@gmail.com randolph.o.webb@gmail.com)
end
