require 'active_support/core_ext'

class Message
  def initialize now = nil
    @right_now = now || Time.now
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
    is_weekend? ? 'Enjoy it while it lasts!' : 'What a drag.'
  end

  def countdown
    reply = {}

    # TODO adjust for client local time, in case they don't use DST
    offset = (@next_event - @right_now).to_f
    #reply[:offset] = offset

    offset = offset / 60 / 60
    reply[:hour] = offset.floor

    offset = (offset - offset.floor) * 60
    reply[:minute] = offset.floor

    offset = (offset - offset.floor) * 60
    reply[:second] = offset.round

    reply
  end

  def to_json
    cd = countdown
    h, m, s = cd[:hour], cd[:minute], cd[:second]
    "{\"answer\":\"#{answer}\",\"comment\":\"#{comment}\",\"next_event\":{\"hours\":#{h},\"minutes\":#{m},\"seconds\":#{s}}}"
  end
end
