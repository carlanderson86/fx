module Fx

  ###
  # Class: BaseProcessorJob
  #
  # @author Carl Anderson
  ###
  class BaseProcessorJob < ApplicationJob

    def initialize
      @data = nil
    end


    def run
      log = Fx::Log.new
      log.save
      log_data = {}





    end

    ###
    # Method: get_data
    #
    # Description: Get the data from the service
    #
    # @author Carl Anderson
    ###
    def get_data
      raise 'get_data must be implemented'
    end

    ###
    # Method: process_data
    #
    # Description: Process the Data we get from the service
    #
    # @author Carl Anderson
    ###
    def process_data
      raise 'process_data must be implemented'
    end

  end

end