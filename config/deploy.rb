# Change these
server '157.230.87.76', user: 'rails', roles: [:web, :app, :db], primary: true

set :repo_url,        'https://Mahroz:e89400a80434f53d218d8faa28001fc43ebb9013@github.com/Mahroz/calwinkle.git'
set :application,     'calwinkle'
set :user,            'rails'
set :puma_threads,    [4, 16]
set :puma_workers,    0

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/aws_key) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord
set :default_env, {
  SECRET_KEY_BASE: '1b5b1c66b6e555360354da677bd93ea32e95401e30b7e1f3e4894b5633883ffd682384a8bb5ef3da87255cec4bf1f265f4413d131705458d52bb89b1243b9dd9',
}

## Defaults:
# set :scm,           :git
set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

# To prevent capistrano from generating binstubs
set :bundle_binstubs, nil

## Linked Files & Directories (Default None):
set :linked_files, %w{config/database.yml}
set :linked_dirs,  %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Symlink Changed Uploads directory to preserve data after deploy'
  task :symlink_directories do
    on roles(:app) do
      execute "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :symlink_directories
  after  :finishing,    :restart
end