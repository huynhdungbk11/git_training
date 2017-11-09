# config valid for current version and patch releases of Capistrano
lock "~> 3.10.0"

set :application, "git_training"
set :repo_url, "https://github.com/huynhdungbk11/git_training"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, 'develop'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/git_training"

# Deploy user
set :deploy_user, "root"
set :use_sudo, true

# Deploy environments
set :stages, %w(production)
set :default_stage, "production"


set :linked_files,
  fetch(:linked_files, [])
  .push("config/database.yml", "config/secrets.yml", "config/unicorn.rb")

set :linked_dirs,
  fetch(:linked_dirs, [])
  .push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do
  desc 'Invoke a rake command'
  task :invoke, [:command] => 'deploy:set_rails_env' do |task, args|
    on primary(:app) do
      within current_path do
        with :rails_env => fetch(:rails_env) do
          rake args[:command]
        end
      end
    end
  end
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
