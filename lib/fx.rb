require "fx/engine"
require 'rufus-scheduler'

module Fx
  # Your code goes here...

  def self.setup(&block)
    @config ||= Fx::Engine::Configuration.new

    yield @config if block

    @config

    scheduler = Rufus::Scheduler.new

    scheduler.cron @config.fx_cron_string, @config.fx_processor

    scheduler.join
  end

  def self.config
    Rails.application.config
  end

end
