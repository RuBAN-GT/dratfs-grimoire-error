guard :bundler do
  require 'guard/bundler'
  require 'guard/bundler/verify'
  helper = Guard::Bundler::Verify.new

  files = ['Gemfile']
  files += Dir['*.gemspec'] if files.any? { |f| helper.uses_gemspec?(f) }

  files.each { |file| watch(helper.real_path(file)) }
end

guard 'livereload' do
  extensions = {
    css: :css,
    scss: :css,
    sass: :css,
    js: :js,
    coffee: :js,
    html: :html,
    png: :png,
    gif: :gif,
    jpg: :jpg,
    jpeg: :jpeg
  }
  rails_view_exts = %w(erb haml slim)

  watch(%r{public/.+\.(#{extensions.values.uniq * '|'})})
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(#{extensions.keys * '|'}))).*}) { |m| "/assets/#{m[3]}" }
  watch(%r{app/views/.+\.(#{rails_view_exts * '|'})$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{config/locales/.+\.yml})
  watch(%r{^(app/models|app/controllers)/.*})
end

guard 'rails' do
  watch('Gemfile.lock')
  watch(%r{^(config/initializers|config/environments|lib)/.*})
end
