require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
#require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, '91.223.16.170'
set :source, '/home/deploy/source/halalgems_source'
set :deploy_to, '/home/deploy/halalgems_production'
# set :repository, 'http://192.168.45.201/svn/sinyong/trunk/WebAdminPortal'
set :branch, 'master'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log', 'public/system']

# Optional settings:
set :user, 'deploy'    # Username in the server to SSH to.
set :term_mode, nil
set :password , '1qazxsw2'
set :port, '22'     # SSH port number.
# set :identity_file, '/keypairs/sinyoong_key01.pem'

set :rails_env, 'production'
# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  #invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use[ruby 1.9.3@rails3]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[mkdir -p "#{deploy_to}/shared/public/system"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public/system"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    # invoke :'svn:checkout'
    # queue %[echo "-----> Extract source"]
    # queue "tar -xvf #{source}.tar.gz"

    queue %[echo "-----> Copy source"]
    queue "cp -r #{source}/* ."
    
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    # invoke :'rails:assets_precompile'

    to :launch do
      # queue "touch #{deploy_to}/current/tmp/restart.txt"
      queue! %[chmod +x "#{deploy_to}/current/bin/rails"]
      #queue "whenever -w"
    end
  end
end

desc "Extract old source"
task :extract_sourcecode => :environment do
  queue "rm -rf /home/deploy/source/halalgems_source"
  queue "unzip -xo /home/deploy/source/halalgems_source.zip -d /home/deploy/source/"
end

desc "Get logs from server."
task :logs => :environment do
  queue "tail -200 #{deploy_to}/current/log/#{rails_env}.log"
end

desc "remove old source"
task :remove_old_source => :environment do
  queue "rm -rf #{source}/*"
end
desc "restart server"
task :restart => :environment do
  queue "touch  #{deploy_to}/current/tmp/restart.txt"
end

# desc "Copy assets"
# task :copy_assets => :environment do
#   queue "cp #{deploy_to}/current/public/assets/fontawesome-webfont*.woff #{deploy_to}/current/public/assets/fontawesome-webfont.woff"
#   queue "cp #{deploy_to}/public/assets/fontawesome-webfont*.tff #{deploy_to}/current/public/assets/fontawesome-webfont.tff"
# end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

