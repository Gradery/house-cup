require 'clockwork'
require_relative './config/boot'
require_relative './config/environment'

module Clockwork

  every(1.day, 'recaculate scores', :at => "00:05") { RecalculateScoresWorker.perform_async() }

end