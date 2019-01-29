# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
Devise.setup do |config|
  require 'devise/orm/active_record'

  config.secret_key = '7ae306a527131fb2a03da83b30074d5784d2a27f1d59860e35d49f58dde9d7d1d107381e1c94c4c5176e0fd681383ff55556f88670db7964d6b81d16f2a793ca'

  config.mailer_sender = 'ghost@fydir.ru'

  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 11

  config.remember_for = 1.months
  config.expire_all_remember_me_on_sign_out = true

  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  config.sign_out_via = :delete

  config.omniauth :bungie,
    '053c28e654c84b83be3bfe3039c45401',
    'https://www.bungie.net/en/Application/Authorize/11253',
    :origin => 'https://grimoire.fydir.ru'
end
