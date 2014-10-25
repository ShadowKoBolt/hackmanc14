namespace :daemon do

  desc "Restart daemon"
  task :restart do
    on roles([:app]) do
      execute "cd #{release_path} && ENVIRONMENT=#{fetch(:stage)} bundle exec ./daemon restart"
    end
  end

end
