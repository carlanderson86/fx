module Fx

  ###
  # Module: CurrencyHelper
  #
  # @author Carl Anderson
  ###
  module CurrencyHelper

    ###
    # Method: currencies_lookup
    #
    # Description: Get the currencies from the system
    #
    # @author Carl Anderson
    ###
    def self.currencies_lookup

      currencies = Currency.where('is_active=?',true)
      result = []
      currencies.each do |currency|
        label = "#{currency.label} (#{currency.symbol})"

        result.push({
          id:currency.code,
          text:label
        })
      end

      return result
    end
  end
end