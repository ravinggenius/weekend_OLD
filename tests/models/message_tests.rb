require 'shoulda'

require File.join(File.dirname(__FILE__), '/../../models/message')

class MessageTests < Test::Unit::TestCase
  context 'A new Message' do
    setup do
      @m = Message.new
    end

    should 'get the basics right' do
      [
        :answer,
        :comment,
        :countdown,
        :is_weekend?
      ].each { |method| assert @m.respond_to?(method), "Message.new does not respond to :#{method}" }
    end

    should 'have some defaults' do
    end
  end
end
