require 'bundler/capistrano' #Using bundler with Capistrano

set :application, "blog"
set :repository,  "git://github.com/hi54yt/blog.git"

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :user, "bestyt"
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
set :branch, "master"
default_run_options[:pty] = true

set :deploy_env, "production"
set :rails_env, "production"

server "42.120.21.5", :web, :app, :db, :primary => true


namespace :deploy do 
  desc "restart" 
  task :restart do
    run "touch #{current_path}/tmp/restart.txt" 
  end
end

desc "Create database.yml and asset packages for production" 
after("deploy:update_code") do
  db_config = "#{shared_path}/config/database.example.yml"
  run "cp #{db_config} #{release_path}/config/database.yml" 
end