require 'test_helper'

class WeekendAppTest < Test::Unit::TestCase
  context "WeekendApp" do
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
