#!/usr/bin/env ruby
require 'rubygems'
require 'daemons'
require 'bundler/setup'
Bundler.require

require './app/game.rb'

def stop_and_exit
  puts "Stopping server"
  exit 0
end

Signal.trap('INT') { stop_and_exit }
Signal.trap('TERM'){ stop_and_exit }

options = {
  :app_name => 'dotb-server',
  :multiple => false,
  :log_output => true,
  :dir_mode => :normal,
  :dir => 'log'
}

Daemons.run('server.rb', options)
