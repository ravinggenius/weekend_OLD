require 'shoulda'
require 'json'
require 'tzinfo'

require File.join(File.dirname(__FILE__), '/../../models/message')

class MessageTests < Test::Unit::TestCase
  context 'A new Message for UTC' do
    setup do
      @time = Time.utc 2010
      @m = Message.new :time => @time
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

  context 'A new Message for local time' do
    setup do
      @time = Time.utc 2010
      @m = Message.new :time => @time, :zone => 'America/New_York'
    end

    should 'correctly convert to JSON' do
      expected = JSON.parse '{
  "answer": "No",
  "comment": "What a drag.",
  "next_event": {
    "hours": 22,
    "minutes": 0,
    "seconds": 0
  }
}'
      assert_equal expected, JSON.parse(@m.to_json)
    end
  end

  context 'A new Message with a invalid timezone given' do
    setup do
      @time = Time.utc 2010
      @m = Message.new :time => @time, :zone => 'Solar_System/Mars'
    end

    should 'default to Etc/UTC and correctly convert to JSON' do
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

  context 'A new Message on Monday morning' do
    setup do
      @time = Time.utc 2010, 'mar', 1, 7, 15, 0
      @m = Message.new :time => @time
    end

    should 'not add a week to countdown' do
      expected = JSON.parse '{
  "answer": "Yes",
  "comment": "Enjoy it while it lasts!",
  "next_event": {
    "hours": 0,
    "minutes": 45,
    "seconds": 0
  }
}'
      assert_equal expected, JSON.parse(@m.to_json)
    end
  end
end
