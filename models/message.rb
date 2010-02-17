require 'active_support/core_ext'
require 'active_support/json'

class Message
  attr_reader :answer, :comment, :countdown

  def initialize
    @right_now = Time.now
    @next_event = @right_now.monday + (is_weekend? ? 1.week + 8.hours : 4.days + 17.hours)
  end

  def is_weekend?
    @is_weekend ||= case @right_now.wday
      when 0, 6 then true                  # sunday, saturday
      when    1 then @right_now.hour < 8   # monday
      when    5 then @right_now.hour >= 17 # friday
      else           false
    end
  end

  def answer
    is_weekend? ? 'Yes' : 'No'
  end

  def comment
    is_weekend? ? 'Enjoy it will it last!' : 'What a drag.'
  end

  def countdown
    countdown = {}

    # TODO adjust for client local time, in case they don't use DST
    offset = (@next_event - Time.now).to_f
    #countdown[:offset] = offset

    offset = offset / 60 / 60
    countdown[:hour] = offset.floor

    offset = (offset - offset.floor) * 60
    countdown[:minute] = offset.floor

    offset = (offset - offset.floor) * 60
    countdown[:second] = offset.round

    countdown
  end
end
