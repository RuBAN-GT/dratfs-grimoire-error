# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Load git
require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

# rbenv
require 'capistrano/rbenv'

# For rails
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'

# Passenger
require 'capistrano/passenger'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
