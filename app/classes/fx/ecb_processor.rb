module Fx
  class EcbProcessor < BaseProcessor

    def initialize
      super
    end

    ###
    # Method: configure_log
    #
    # Description: Configure the log
    #
    # @author Carl Anderson
    ###
    def configure_log
      @log.label = 'ECB Processor'
    end

    ###
    # Method: get_data
    #
    # Description: Get the data from the service
    #
    # @author Carl Anderson
    ###
    def get_data
      uri_string = Fx.config.fx_data_source
      uri = URI(uri_string)
      use_ssl = uri.scheme == 'https'

      Net::HTTP.start(uri.host,uri.port) do |http|
        request = Net::HTTP::Get.new uri.request_uri
        response = http.request request

        if response.present?
          @data = response.body
        end

      end
    end

    ###
    # Method: process_data
    #
    # Description: Process the Data we get from the service
    #
    # @author Carl Anderson
    ###
    def process_data
      currencies = Currency.all
      currency_map = {}

      base_currency_code = Fx.config.base_currency
      base_currency = nil

      # Map the currencies up so we are not calling every loop
      currencies.each do |currency|
        currency_map[currency.code] = currency
        if base_currency_code == currency.code
          base_currency = currency
        end
      end

      # We are making sure new currencies get as much data as possible so we group by the base and target id so it's not just a blanket latest_date
      # Storing this at the start means we can just run it all through for as much data as we have
      latest_dates = Conversion.select('target_currency_id, MAX(timestamp) as timestamp').where('base_currency_id=?',base_currency.id).group('target_currency_id')
      latest_date_map = {}
      latest_dates.each do |latest_date|
        latest_date_map[latest_date.target_currency_id] = latest_date.timestamp
      end

      xml_doc  = Nokogiri::XML(@data)
      xml_doc.remove_namespaces!

      nodes = xml_doc.xpath('//Envelope/Cube/Cube')

      @log_data[:conversions_added] = 0
      @log_data[:dates_handled] = []


      ActiveRecord::Base.transaction do
        nodes.each do |node|
          process_data_entry(parent_node:node, currency_map:currency_map, base_currency:base_currency, latest_date_map:latest_date_map)
        end
      end

    end

    ###
    # Method: process_data_entry
    #
    # Description: Process the data entry
    #
    # @author Carl Anderson
    ###
    def process_data_entry(parent_node:, currency_map:, base_currency:, latest_date_map:)
      # Get the time
      time = parent_node['time']
      time.to_datetime.beginning_of_day

      @log_data[:dates_handled].push(time)

      # For the date, make a conversion for the base
      latest_date = latest_date_map[base_currency.id]
      if latest_date.nil? || time > latest_date
        conversion = Conversion.new
        conversion.base_currency_id = base_currency.id
        conversion.target_currency_id = base_currency.id
        conversion.timestamp = time
        conversion.rate = 1
        conversion.save
        @log_data[:conversions_added] += 1
      end

      latest_date = nil

      nodes = parent_node.xpath('Cube')
      nodes.each do |node|
        # Get the currency, if nil, next
        currency = currency_map[node['currency']]
        if currency.blank?
          next
        end

        # Get the latest date, unless it is nil or a new entry, next
        latest_date = latest_date_map[currency.id]
        unless latest_date.nil? || time > latest_date
          next
        end

        # Create entry
        conversion = Conversion.new
        conversion.base_currency_id = base_currency.id
        conversion.target_currency_id = currency.id
        conversion.timestamp = time
        conversion.rate = node['rate']
        conversion.save

        @log_data[:conversions_added] += 1
      end

    end

  end
end