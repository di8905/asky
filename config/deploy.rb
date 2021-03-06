# config valid only for current version of Capistrano
lock "3.7.1"

set :application, "asky"
set :repo_url, "git@github.com:di8905/asky.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/asky"
set :deploy_user, 'deployer'

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, 
        "config/database.yml",
        "config/secrets.yml",
        ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log",
                     "tmp/pids",
                     "tmp/cache",
                     "tmp/sockets",
                     "public/system",
                     'public/uploads',
                     'db/sphinx'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end
  
  after :publishing, :restart
end
