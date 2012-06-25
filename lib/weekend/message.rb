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
      reply = @right_now.monday + (weekend? ? 1.week + 8.hours : 4.days + 17.hours)
      (@right_now.monday? && (@right_now.hour < 8)) ? (reply - 1.week) : reply
    end.call
  end

  def weekend?
    case
      when @right_now.sunday?   then true
      when @right_now.monday?   then @right_now.hour < 8
      when @right_now.friday?   then @right_now.hour >= 17
      when @right_now.saturday? then true
      else                           false
    end
  end

  def answer
    weekend? ? 'Yes' : 'No'
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
end
