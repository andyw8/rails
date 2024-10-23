# frozen_string_literal: true

# :markup: markdown

require "active_support/benchmarkable"

module AbstractController
  module Logger # :nodoc:
    extend ActiveSupport::Concern

    include ActiveSupport::Benchmarkable
    included do
      config_accessor :logger
    end
  end
end
