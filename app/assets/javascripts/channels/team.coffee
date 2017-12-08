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
        if data.event == "move_card"
          $("#tmp-card-container").append($(".card[card_id='"+data.card_id+"']"))
          if data.order == 1
            $(".card-container[list_id='"+data.list_id+"']").prepend($(".card[card_id='"+data.card_id+"']"))
          else
            $(".card-container[list_id='"+data.list_id+"'] div:eq("+(data.order-2)+")").after($(".card[card_id='"+data.card_id+"']"))

        else if data.event == "create_tag" || data.event == "bind_tag"
          if data.event == "create_tag"
            $('#tag-modal-dialog').find('#tag-list').append('<div class="tag-in-list"><span class="edit-tag"></span><span class="card-tag mod-selectable card-tag-color-label selected card-tag-color-'+data.tag_color+'" data-color-id="'+data.tag_color+'" data-tag-id="'+data.tag_id+'">'+data.tag_name+'<span class="icon-sm icon-check card-label-selectable-icon light"></span></span></div>')
            cardTagClick()
          $('.card[card_id="'+data.card_id+'"]').find('.card-out-tag-container').append('<span class="card-tag-color-label tag outside-tag card-tag-color-'+data.tag_color+'" data-color-id="'+data.tag_color+'" data-tag-id="'+data.tag_id+'">'+data.tag_name+'</span>')
          $('#modal-card-id[data-card-id="'+data.card_id+'"]').find('.tags-container #show-tags-modal').before('<span class="tag card-tag-color-label card-tag-color-'+data.tag_color+'" data-color-id="'+data.tag_color+'" data-tag-id="'+data.tag_id+'">'+data.tag_name+'</span>');
        else if data.event == "unbind_tag"
          $('.card[card_id="'+data.card_id+'"]').find('.card-out-tag-container span.tag[data-tag-id="'+data.tag_id+'"]').remove()
          $('#modal-card-id[data-card-id="'+data.card_id+'"]').find('.tags-container span.tag[data-tag-id="'+data.tag_id+'"]').remove()
        else if data.event == "add_member_to_card"
          $('#modal-card-id[data-card-id="'+data.card_id+'"]').find('.card-member-container #show-members-modal').before('<div class="card-member"><span class="member-initials" data-user-id="'+data.user_id+'">'+data.user_name[0].toUpperCase()+'</span></div>')
          $('#modal-card-id[data-card-id="'+data.card_id+'"]').find('.member-in-list[data-user-id='+data.user_id+']').addClass('member-selected');
        else if data.event == "delete_member_from_card"
          $('#modal-card-id[data-card-id="'+data.card_id+'"]').find('.card-member-container .member-initials[data-user-id="'+data.user_id+'"]').parent().remove()
        else if data.event == "edit_card_description"
          $('#modal-card-id[data-card-id="'+data.card_id+'"]').find('.description').html(data.description)
        else if data.event == "create_comment"
          html = ""
          html = html.concat('<div class="comment-container"><div class="headshot"><span class="member-initials">'+data.from_user_name[0].toUpperCase()+'</span></div><span class="username">'+data.from_user_name+'</span><span class="sent-date">posted on '+data.created_at+'</span><br/><div class="comment-content">')
          if data.to_user_id != null
            html = html.concat('<span class="at-user">@'+data.to_user_name+'</span>')
          html = html.concat('<span class="comment">'+data.context+'</span></div></div>');
          $('#modal-card-id[data-card-id="'+data.card_id+'"]').find('.comments-list').append(html)
        # Called when there's incoming data on the websocket for this channel
