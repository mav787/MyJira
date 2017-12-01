class TeamChannel < ApplicationCable::Channel
  def subscribed
    stream_from "team_#{params['board_id']}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
