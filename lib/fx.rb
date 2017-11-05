require "fx/engine"
require 'rufus-scheduler'

module Fx


  def self.setup(&block)
    @config ||= Fx::Engine::Configuration.new

    yield @config if block

    @config

    Rails.logger.debug "== Initialising FX =="
    Rails.logger.debug "Processor #{@config.fx_processor}"
    Rails.logger.debug "Cron String #{@config.fx_cron_string}"
    Rails.logger.debug "Base Currency #{@config.base_currency}"
    Rails.logger.debug "== Fx Initialised =="

    scheduler = Rufus::Scheduler.new

    scheduler.cron @config.fx_cron_string, @config.fx_processor
  end

  def self.config
    Rails.application.config
  end

end
