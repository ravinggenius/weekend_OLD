require_relative '../lib/boot'

require 'cover_me'
require 'rspec'
require 'rspec/autorun'

RSpec.configure do |config|
  config.color = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
