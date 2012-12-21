# -*- encoding : utf-8 -*-
set :application, "nacer"
set :repository,  "http://github.com/sbosio/nacer"

set :scm, :git
set :deploy_to, "/var/www"

role :web, "10.101.248.68"
role :app, "10.101.248.68"
role :db,  "10.101.248.68", :primary => true

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
