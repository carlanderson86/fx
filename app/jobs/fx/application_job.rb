module Fx
  class ApplicationJob < ActiveJob::Base
    queue_as :default
  end
end
