lock '3.2.1'
set :application, 'dotb'
set :repo_url, 'git@github.com:ShadowKoBolt/hackmanc14.git'
set :deploy_to, '/var/www/hackman.llamadigital.net'
set :scm, :git
set :linked_dirs, %w{log}
set :keep_releases, 5

namespace :deploy do
  after :published, 'daemon:restart'
end
