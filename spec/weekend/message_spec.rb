require_relative '../spec_helper'

require 'weekend/message'

describe Message do
  subject { Message.new :time => time }

  context 'at the very start of the timer' do
    it 'counts down the longest on Monday morning at 8:00'
  end

  context 'an invalid timezone' do
    let(:time) { Time.utc 2010 }
    subject { Message.new :time => time, :zone => 'Solar_System/Mars' }

    it { should_not be_is_weekend }
    its(:countdown) { should == { :hours => 17, :minutes => 00, :seconds => 00 } }
  end

  context 'Monday morning' do
    let(:time) { Time.utc 2010, 03, 01, 07, 15, 00 }

    it { should be_is_weekend }
    its(:countdown) { should == { :hours => 00, :minutes => 45, :seconds => 00 } }
  end

  context 'on the weekend (UTC)' do
    let(:time) { Time.utc 2010, 10, 10, 10, 10, 10 }

    it { should be_is_weekend }
    its(:answer) { should == 'Yes' }
    its(:countdown) { should == { :hours => 21, :minutes => 49, :seconds => 50 } }
  end

  context 'during the week (UTC)' do
    let(:time) { Time.utc 2011, 11, 11, 11, 11, 11 }

    it { should_not be_is_weekend }
    its(:answer) { should == 'No' }
    its(:countdown) { should == { :hours => 5, :minutes => 48, :seconds => 49 } }
  end

  context 'on the weekend (local)' do
    let(:time) { Time.utc 2011, 01, 01, 16, 35, 12 }
    subject { Message.new :time => time, :zone => 'America/New_York' }

    it { should be_is_weekend }
    its(:answer) { should == 'Yes' }
    its(:countdown) { should == { :hours => 44, :minutes => 24, :seconds => 48 } }
  end

  context 'during the week (local)' do
    let(:time) { Time.utc 2010, 01, 05, 13, 45, 37 }
    subject { Message.new :time => time, :zone => 'America/New_York' }

    it { should_not be_is_weekend }
    its(:answer) { should == 'No' }
    its(:countdown) { should == { :hours => 80, :minutes => 14, :seconds => 23 } }
  end
end
