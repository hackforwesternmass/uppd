#$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the 
require 'rvm/capistrano'  # Add RVM integration
require 'bundler/capistrano'  # Add Bundler integration

ssh_options[:forward_agent] = true
set :deploy_via, :remote_cache
set :use_sudo, false
load 'deploy/assets'

set :application, "uppd"
set :user, "deploy"
set :deploy_to, "/var/www/uppd"

default_run_options[:pty] = true  # Must be set for the password prompt
                                  # from git to work

set :repository, "https://github.com/hackforwesternmass/uppd.git"  # Your clone URL
#set :local_repository, "file://."
#set :deploy_via, :copy

set :scm, :git
set :branch, "master"
default_run_options[:pty] = true


# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "75.98.173.74"                          # Your HTTP server, Apache/etc
role :app, "75.98.173.74"                          # This may be the same as your `Web` server
role :db,  "75.98.173.74", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end