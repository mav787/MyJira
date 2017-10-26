json.extract! comment, :id, :context, :from_user_id, :card_id, :to_user_id, :created_at, :updated_at
json.url comment_url(comment, format: :json)
