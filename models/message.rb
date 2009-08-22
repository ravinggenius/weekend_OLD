require 'rubygems'
require 'activesupport'

class Message
  attr_reader :answer, :comment, :countdown

  def initialize
    right_now = Time.now

    @is_weekend = case right_now.wday
      when 0, 6 then true                 # sunday, saturday
      when    1 then right_now.hour < 8   # monday
      when    5 then right_now.hour >= 17 # friday
      else           false
    end

    @next_event = right_now.monday + (@is_weekend ? 1.week + 8.hours : 4.days + 17.hours)
  end

  def answer
    if @is_weekend
      'Yes'
    else
      'No'
    end
  end

  def comment
    if @is_weekend
      'Enjoy it will it last!'
    else
      'What a drag.'
    end
  end

  def countdown
    countdown = {}

    # todo: adjust for client local time, in case they don't use DST
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

  # needed for sinatra
  #def to_json
  #  cd = countdown
  #  <<JSON
#{"answer": "#{answer}", "comment": "#{comment}", "countdown": {"hour": #{cd[:hour]}, "minute": #{cd[:minute]}, "second": #{cd[:second]}}}
#JSON
  #end
end

