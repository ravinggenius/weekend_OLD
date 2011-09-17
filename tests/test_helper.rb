$:.unshift File.expand_path('../../models', __FILE__)

require 'cover_me'

require_relative '../boot'

require 'minitest/autorun'

class TestHelper < MiniTest::Unit::TestCase
end
