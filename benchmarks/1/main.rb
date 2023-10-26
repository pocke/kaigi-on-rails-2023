# frozen_string_literal: true

require_relative '../base'
require_relative './base'

Benchmark.ips do |x|
  x.report("A") do
    a
  end

  x.report("B") do
    b
  end

  x.compare!
end
