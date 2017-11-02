require "fx/engine"

module Fx
  # Your code goes here...

  def self.setup
    super

    scheduler = Rufus::Scheduler.start_new

    scheduler.in '4s' do
      autocallprocess_method
    end

    scheduler.every '1m' do
      autocallprocess_method
    end
  end

end
