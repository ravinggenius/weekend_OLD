require 'active_support/core_ext'
require 'tzinfo'

class Message
  def initialize options = {}
    @right_now = begin
      TZInfo::Timezone.get options[:zone]
    rescue TZInfo::InvalidTimezoneIdentifier
      TZInfo::Timezone.get 'Etc/UTC'
    end.utc_to_local(options[:time] || Time.new.utc)

    @next_event = @right_now.monday + (is_weekend? ? 1.week + 8.hours : 4.days + 17.hours)
    @next_event = (@next_event - 1.week) if (@right_now.wday == 1) && (@right_now.hour < 8)
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

    offset = (@next_event - @right_now).to_f

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
