require 'shoulda'
require 'json'

require File.join(File.dirname(__FILE__), '/../../models/message')

class MessageTests < Test::Unit::TestCase
  context 'A new Message' do
    setup do
      @now = Time.local 2010
      @m = Message.new @now
    end

    should 'get the basics right' do
      [
        :answer,
        :comment,
        :countdown,
        :is_weekend?,
        :to_json
      ].each { |method| assert @m.respond_to?(method), "Message.new does not respond to :#{method}" }
    end

    should 'correctly convert to JSON' do
      expected = JSON.parse '{
  "answer": "No",
  "comment": "What a drag.",
  "next_event": {
    "hours": 17,
    "minutes": 0,
    "seconds": 0
  }
}'
      assert_equal expected, JSON.parse(@m.to_json)
    end
  end
end
