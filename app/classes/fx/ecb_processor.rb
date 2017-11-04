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
      latest_date = Conversion.select('MAX(timestamp) as timestamp').take
      if latest_date.present?
        latest_date = latest_date.timestamp.beginning_of_day
      end

      currencies = Currency.all
      currency_map = {}

      base_currency_code = Fx.config.base_currency
      base_currency = nil

      currencies.each do |currency|
        currency_map[currency.code] = currency
        if base_currency_code == currency.code
          base_currency = currency
        end
      end

      xml_doc  = Nokogiri::XML(@data)
      xml_doc.remove_namespaces!
      envelope_nodes = xml_doc.xpath('//Envelope/Cube/Cube')

      nodes = xml_doc.xpath('//Envelope/Cube/Cube')
      Rails.logger.debug "Latest Date: #{latest_date}"
      ActiveRecord::Base.transaction do
        nodes.each do |node|
          time = node['time']
          time.to_datetime.beginning_of_day

          if latest_date.blank? || time > latest_date
            process_data_entry(parent_node:node, currency_map:currency_map, base_currency:base_currency, timestamp:time)
          end

        end
      end

    end

    def process_data_entry(parent_node:, currency_map:, base_currency:, timestamp:)

      nodes = parent_node.xpath('//Cube')
      nodes.each do |node|
        currency = currency_map[node['currency']]
        if currency.blank?
          next
        end

        conversion = Conversion.new
        conversion.base_currency_id = base_currency.id
        conversion.target_currency_id = currency.id
        conversion.timestamp = timestamp
        conversion.rate = node['rate']
        conversion.save
      end

    end

  end
end