load 'deploy' if respond_to?(:namespace) # cap2 differentiator

# Run with pty to be able to use 'sudo'
default_run_options[:pty] = true
default_run_options[:shell] = '/bin/bash -l'

# Uncomment if you are using Rails' asset pipeline
load 'deploy/assets'

Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }


load 'config/deploy' # remove this line to skip loading any of the default tasks
