require_relative '../test_case'

require 'weekend/message'
require 'weekend/message_presenter'

describe MessagePresenter do
  let(:time) { Time.utc(2010) }
  let(:message) { Message.new(:time => time) }
  subject { MessagePresenter.new(message) }

  it 'should get the basics right' do
    [
      :as_json,
      :to_json
    ].each { |method| subject.must_respond_to method }
  end

  it 'should respond with a full Hash when #as_json is called' do
    expected = {
      :answer => 'No',
      :next_event => {
        :hours => 0,
        :minutes => 0,
        :seconds => 0
      }
    }
    subject.as_json.must_equal expected
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
    JSON.parse(subject.to_json).must_equal expected
  end
end
