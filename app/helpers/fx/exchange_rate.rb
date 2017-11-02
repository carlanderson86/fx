module Fx
  module ExchangeRate


    def self.at(date,from_currency_code,to_currency_code)

      from_conversion = Conversion.where('timestamp=? AND from_currency_id=(SELECT c.id FROM currencies c WHERE c.code=?)',date.beginning_of_day,from_currency_code).take
      to_conversion = Conversion.where('timestamp=? AND to_currency_id=(SELECT c.id FROM currencies c WHERE c.code=?)',date.beginning_of_day,to_currency_code).take

      if from_conversion.blank? || to_conversion.blank?
        return nil
      end

      exchange_rate = ExchangeRate.calculate_conversion(from_conversion:from_conversion, to_conversion: to_conversion)

      return exchange_rate
    end

    def self.calculate_conversion(from_conversion:,to_conversion:)
      result = to_conversion.rate / from_conversion.rate
      return result
    end

  end
end