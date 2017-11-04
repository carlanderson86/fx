module Fx

  class BaseProcessor

    def initialize


    end

    def call(job)
      ActiveRecord::Base.connection_pool.with_connection do
        @data = nil
        @log = Fx::Log.new
        configure_log
        @log_data = {}
        @log.save
        begin
          @data = get_data
          process_data

          @log.status = Log::LOG_SUCCESS
        rescue Exception => e
          @log.status = Log::LOG_FAILED
          @log_data[:error] = e.message
          @log_data[:backtrace] = e.backtrace
        end

        @log.result = @log_data
        @log.save
      end
    end

    ###
    # Method: configure_log
    #
    # Description: Configure the log
    #
    # @author Carl Anderson
    ###
    def configure_log

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