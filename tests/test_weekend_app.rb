require 'rubygems'
require 'test_helper'

class WeekendAppTest < Test::Unit::TestCase
  context "WeekendApp" do
    context "Models" do
      context "Message" do
        setup do
          @m = Message.new
        end

        should "not be the weekend" do
          assert_false @m.is_weekend
        end
      end
    end

    context "Controllers" do
      context "get /" do
        setup do
          get '/'
        end

        should "respond" do
          assert body
        end
      end
    end
  end
end
