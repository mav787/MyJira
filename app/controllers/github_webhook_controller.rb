class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor

  # Handle push event
  def github_push
    puts "here"
    params["commits"].each do |c|
      Card.new(content: c["message"], list_id: 7).save
    end
  end


  private

  def webhook_secret(payload)
    "a_gr34t_s3cr3t"
  end
end
