Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.precompile += %w(web/specific/*.js web/specific/*.css)
Rails.application.config.assets.precompile += %w(*.svg *.eot *.ttf *.woff *.woff2)
Rails.application.config.assets.precompile += %w(*.map)

Rails.application.config.assets.precompile += %w(web/server_rendering.js)

Rails.application.config.assets.precompile += %w(ckeditor/*)

Rails.application.config.assets.precompile += %w(rails_admin/rails_admin.css rails_admin/rails_admin.js)
