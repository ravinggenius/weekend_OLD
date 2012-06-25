require_relative '../spec_helper'

require 'weekend/message'

describe Message do
  subject { Message.new }

  it 'counts down the longest on Monday morning at 8:00'

  describe 'an invalid timezone' do
    let(:time) { Time.utc 2010 }
    subject { Message.new :time => time, :zone => 'Solar_System/Mars' }

    it 'is not the weekend' do
      expect(subject.is_weekend?).to be_false
      expect(subject.answer).to eq('No')
    end

    it 'countdown must be accurate' do
      expect(subject.countdown).to eq(:hours => 17, :minutes => 0, :seconds => 0)
    end
  end

  describe 'Monday morning' do
    let(:time) { Time.utc 2010, 3, 1, 7, 15, 0 }
    subject { Message.new :time => time }

    it 'is the weekend' do
      expect(subject.is_weekend?).to be_true
      expect(subject.answer).to eq('Yes')
    end

    it 'countdown must be accurate' do
      expect(subject.countdown).to eq(:hours => 0, :minutes => 45, :seconds => 0)
    end
  end

  describe 'UTC' do
    describe 'A new weekend Message for UTC' do
      let(:time) { Time.utc 2010, 10, 10, 10, 10, 10 }
      subject { Message.new :time => time }

      it 'is the weekend' do
        expect(subject.is_weekend?).to be_true
        expect(subject.answer).to eq('Yes')
      end

      it 'countdown must be accurate' do
        expect(subject.countdown).to eq(:hours => 21, :minutes => 49, :seconds => 50)
      end
    end

    describe 'A new weekday Message for UTC' do
      let(:time) { Time.utc 2011, 11, 11, 11, 11, 11 }
      subject { Message.new :time => time }

      it 'is not the weekend' do
        expect(subject.is_weekend?).to be_false
        expect(subject.answer).to eq('No')
      end

      it 'countdown must be accurate' do
        expect(subject.countdown).to eq(:hours => 5, :minutes => 48, :seconds => 49)
      end
    end
  end

  describe 'Local' do
    describe 'A new weekday Message' do
      let(:time) { Time.utc 2010, 01, 05, 13, 45, 37 }
      subject { Message.new :time => time, :zone => 'America/New_York' }

      it 'is not the weekend' do
        expect(subject.is_weekend?).to be_false
        expect(subject.answer).to eq('No')
      end

      it 'countdown must be accurate' do
        expect(subject.countdown).to eq(:hours => 80, :minutes => 14, :seconds => 23)
      end
    end

    describe 'A new weekend Message' do
      let(:time) { Time.utc 2011, 01, 01, 16, 35, 12 }
      subject { Message.new :time => time, :zone => 'America/New_York' }

      it 'is the weekend' do
        expect(subject.is_weekend?).to be_true
        expect(subject.answer).to eq('Yes')
      end

      it 'countdown must be accurate' do
        expect(subject.countdown).to eq(:hours => 44, :minutes => 24, :seconds => 48)
      end
    end
  end
end