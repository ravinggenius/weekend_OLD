require_relative '../spec_helper'

require 'weekend/message'
require 'weekend/message_presenter'

describe MessagePresenter do
  let(:time) { Time.utc(2010) }
  let(:the_message) { Message.new(:time => time) }
  subject { MessagePresenter.new(the_message) }

  describe '#as_json' do
    it 'responds with a full Hash when #as_json is called' do
      expected = {
        :answer => 'No',
        :next_event => {
          :hours => 17,
          :minutes => 0,
          :seconds => 0
        }
      }
      subject.as_json.should == expected
    end
  end

  describe '#to_json' do
    it 'correctly converts to JSON' do
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
      JSON.parse(subject.to_json).should == expected
    end
  end
end
