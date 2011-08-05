require 'active_support/core_ext'
require 'tzinfo'

class Message
  def initialize(options = {})
    @right_now = lambda do
      begin
        TZInfo::Timezone.get options[:zone]
      rescue TZInfo::InvalidTimezoneIdentifier
        TZInfo::Timezone.get 'Etc/UTC'
      end.utc_to_local(options[:time] || Time.new.utc)
    end.call

    @next_event = lambda do
      reply = @right_now.monday + (is_weekend? ? 1.week + 8.hours : 4.days + 17.hours)
      (@right_now.monday? && (@right_now.hour < 8)) ? (reply - 1.week) : reply
    end.call
  end

  def is_weekend?
    case
      when @right_now.sunday?   then true
      when @right_now.monday?   then @right_now.hour < 8
      when @right_now.friday?   then @right_now.hour >= 17
      when @right_now.saturday? then true
      else                           false
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
    reply[:hours] = offset.floor

    offset = (offset - offset.floor) * 60
    reply[:minutes] = offset.floor

    offset = (offset - offset.floor) * 60
    reply[:seconds] = offset.round

    reply
  end

  def as_json
    {
      :answer => answer,
      :comment => comment,
      :next_event => countdown
    }
  end

  def to_json
    as_json.to_json
  end
end
