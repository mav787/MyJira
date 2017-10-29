json.array! @notifications do |notification| 
    json.recipient notification.recipient 
    json.card notification.card 
    json.url card_path(notification.card, anchor: dom_id(notification.card)) 
end 