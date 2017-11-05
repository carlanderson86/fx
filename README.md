# Fx
Currency exchange library

Current limitation is it expects to use the configured base currency.  
This can be changed by adding more into the method called by the user, the method is already there but simply calling Fx::ExchangeRate.at will get you the exchange rate for the current configured base currency 

## Usage

Configuration Values:

    config.fx_cron_string = '1 0 * * *'
    config.fx_data_source = 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml'
    config.fx_processor = Fx::EcbProcessor
    config.base_currency = 'EUR'
    
You can set these in an initializer such as:

    unless File.basename($0) == 'rake'
      Fx.setup do |config|
        config.fx_cron_string = '1 0 * * *'
        config.fx_data_source = 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml'
        config.fx_processor = Fx::EcbProcessor
        config.base_currency = 'EUR'
      end
    end
    
### Extension

To extend the currency processing without changing the gem the processor can be pointed at a class in your application.
Make the class extend Fx::BaseProcessor and override the methods below.

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

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'fx'
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install fx
```

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
