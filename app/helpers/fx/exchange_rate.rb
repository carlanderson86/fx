module Fx
  module ExchangeRate

    ###
    # Method: at
    #
    # Description: Conversion between two currencies
    #
    # @author Carl Anderson
    ###
    def self.at(date,from_currency_code,to_currency_code)

      base_currency = Currency.where('code=?',Fx.config.base_currency).take

      if base_currency.blank?
        return nil
      end

      return ExchangeRate.at_with_base_currency(date, from_currency_code, to_currency_code, base_currency)
    end

    ###
    # Method: at_with_base_currency
    #
    # Description: Rate at with a selected base currency
    #
    # @author Carl Anderson
    ###
    def self.at_with_base_currency(date,from_currency_code,to_currency_code,base_currency)
      # Assumption of single base currency
      from_conversion = Conversion.where('timestamp=? AND base_currency_id=? AND target_currency_id=(SELECT c.id FROM fx_currencies c WHERE c.code=?)',date.beginning_of_day,base_currency.id,from_currency_code).take
      to_conversion = Conversion.where('timestamp=? AND base_currency_id=? AND target_currency_id=(SELECT c.id FROM fx_currencies c WHERE c.code=?)',date.beginning_of_day,base_currency.id,to_currency_code).take

      if from_conversion.blank? || to_conversion.blank?
        return nil
      end

      exchange_rate = ExchangeRate.calculate_conversion(from_conversion:from_conversion, to_conversion: to_conversion)
      return exchange_rate
    end

    ###
    # Method: converted_value
    #
    # Description: Converted value using an exchange rate
    #
    # @author Carl Anderson
    ###
    def self.converted_value(exchange_rate, value)
      return exchange_rate * value
    end

    private

    ###
    # Method: calculate_conversion
    #
    # Description: Calculate conversion, same base rate
    #
    # @author Carl Anderson
    ###
    def self.calculate_conversion(from_conversion:,to_conversion:)
      Rails.logger.debug "Converting between #{from_conversion.rate} and #{to_conversion.rate}"
      Rails.logger.debug "#{to_conversion.rate} / #{from_conversion.rate} = #{to_conversion.rate/from_conversion.rate}"
      result = to_conversion.rate / from_conversion.rate
      return result
    end

  end
end