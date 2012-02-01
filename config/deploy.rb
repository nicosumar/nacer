set :application, "nacer"
set :repository,  "http://github.com/sbosio/nacer"

set :scm, :git
set :deploy_to, "/var/www"

role :web, "192.168.1.64"
role :app, "192.168.1.64"
role :db,  "192.168.1.64", :primary => true

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
