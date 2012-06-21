class MessagePresenter
  attr_reader :message

  def initialize(message)
    @message = message
  end

  def as_json
    {
      :answer => message.answer,
      :next_event => message.countdown
    }
  end

  def to_json
    as_json.to_json
  end
end
