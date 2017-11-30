jQuery(document).on 'turbolinks:load', ->
  board = $("#board-id")
  if $("#board-id").length > 0

    App.team = App.cable.subscriptions.create {
        channel: "TeamChannel"
        board_id: $("#board-id").data("board-id")
      },
      connected: ->
        # Called when the subscription is ready for use on the server

      disconnected: ->
        # Called when the subscription has been terminated by the server

      received: (data) ->
        $("#tmp-card-container").append($(".card[card_id='"+data.card_id+"']"))
        if data.order == 1
          $(".card-container[list_id='"+data.list_id+"']").prepend($(".card[card_id='"+data.card_id+"']"))
        else
          $(".card-container[list_id='"+data.list_id+"'] div:eq("+(data.order-2)+")").after($(".card[card_id='"+data.card_id+"']"))


        # Called when there's incoming data on the websocket for this channel
