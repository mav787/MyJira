json.extract! board, :id, :name, :leader_id, :created_at, :updated_at
json.url board_url(board, format: :json)
