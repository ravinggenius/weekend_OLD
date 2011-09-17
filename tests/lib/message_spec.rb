require_relative '../test_helper'

require 'json'
require 'tzinfo'

require 'message'

describe 'A new Message for UTC' do
  before do
    @time = Time.utc 2010
    @m = Message.new :time => @time
  end

  it 'should get the basics right' do
    [
      :answer,
      :countdown,
      :is_weekend?,
      :to_json
    ].each { |method| @m.must_respond_to method }
  end

  it 'should correctly convert to JSON' do
    expected = JSON.parse <<-JSON
{
  "answer": "No",
  "next_event": {
    "hours": 17,
    "minutes": 0,
    "seconds": 0
  }
}
    JSON
    JSON.parse(@m.to_json).must_equal expected
  end
end

describe 'A new Message for local time' do
  before do
    @time = Time.utc 2010
    @m = Message.new :time => @time, :zone => 'America/New_York'
  end

  it 'should correctly convert to JSON' do
    expected = JSON.parse <<-JSON
{
  "answer": "No",
  "next_event": {
    "hours": 22,
    "minutes": 0,
    "seconds": 0
  }
}
    JSON
    JSON.parse(@m.to_json).must_equal expected
  end
end

describe 'A new Message with a invalid timezone given' do
  before do
    @time = Time.utc 2010
    @m = Message.new :time => @time, :zone => 'Solar_System/Mars'
  end

  it 'should default to Etc/UTC and correctly convert to JSON' do
    expected = JSON.parse <<-JSON
{
  "answer": "No",
  "next_event": {
    "hours": 17,
    "minutes": 0,
    "seconds": 0
  }
}
    JSON
    JSON.parse(@m.to_json).must_equal expected
  end
end

describe 'A new Message on Monday morning' do
  before do
    @time = Time.utc 2010, 'mar', 1, 7, 15, 0
    @m = Message.new :time => @time
  end

  it 'should not add a week to countdown' do
    expected = JSON.parse <<-JSON
{
  "answer": "Yes",
  "next_event": {
    "hours": 0,
    "minutes": 45,
    "seconds": 0
  }
}
    JSON
    JSON.parse(@m.to_json).must_equal expected
  end
end
