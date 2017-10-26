json.extract! card, :id, :list_id, :content, :deadline, :created_at, :updated_at
json.url card_url(card, format: :json)
