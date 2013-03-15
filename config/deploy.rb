require 'bundler/capistrano' #Using bundler with Capistrano
require "rvm/capistrano"

set :application, "blog"
set :repository,  "git://github.com/hi54yt/blog.git"
set :scm, :git
set :user, "bestyt"
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
set :scm_verbose, true
set :branch, "master"
set :deploy_env, "production"
set :rails_env, "production"
server "42.120.21.5", :web, :app, :db, :primary => true

namespace :deploy do 
  desc "restart" 
  task :restart do
    run "touch #{current_path}/tmp/restart.txt" 
  end
end

namespace :database do 
  desc "Create database.yml and asset packages for production"  
  task :create_database do
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}. create db"
  end
  after "deploy:setup", "database:create_database"
  
  task :symlink_config do
      run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    end
  after "deploy:finalize_update", "database:symlink_config"
end


namespace :deploy do
  namespace :assets do
    desc "Precompile assets on local machine and upload them to the server."
    task :precompile, roles: :web, except: {no_release: true} do
      run_locally "bundle exec rake assets:precompile"
      find_servers_for_task(current_task).each do |server|
        run_locally "rsync -vr --exclude='.DS_Store' public/assets #{user}@#{server.host}:#{shared_path}/"
      end
    end
  end
end