class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor

  # Handle push event
  def github_push(payload)
    payload["commits"].each do |c|
      puts c["message"]
    end
  end


  private

  def webhook_secret(payload)
    "a_gr34t_s3cr3t"
  end
end
