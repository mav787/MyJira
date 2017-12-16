require 'test_helper'

class CardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @card1 = cards(:todo_card1)
    @card2 = cards(:todo_card2)
    @todo_list = lists(:todo)
    @doing_list = lists(:doing)
    @done_list = lists(:done)
  end

  test "should get index" do
    get cards_url
    assert_response :success
  end

  test "should create card" do
    assert_difference('Card.count') do
      post cards_url, params: { card: { content: @card1.content, deadline: @card1.deadline, list_id: @card1.list_id } }
    end
    assert_redirected_to board_url(Card.last.list.board)
  end

  test "should move card within list" do
    assert_difference('@card1.card_order') do
      post '/card/move', params: {card_id: @card1.id, new_list_id: @todo_list.id, new_position: @card1.card_order+1}
      @card1 = Card.find(@card1.id)
    end
  end

  test "should move other card within the same list" do
    assert_difference('@card2.card_order', -1) do
      post '/card/move', params: {card_id: @card1.id, new_list_id: @todo_list.id, new_position: @card1.card_order+1}
      @card2 = Card.find(@card2.id)
    end
  end

  test "should set start time when card moved to doing" do
    assert_nil @card1.startdate
    post '/card/move', params: {card_id: @card1.id, new_list_id: @doing_list.id, new_position: 1}
    @card1 = Card.find(@card1.id)
    assert_not_nil @card1.startdate
  end

  test "should set finish time when card moved to done" do
    assert_nil @card1.finished_at
    post '/card/move', params: {card_id: @card1.id, new_list_id: @doing_list.id, new_position: 1}
    post '/card/move', params: {card_id: @card1.id, new_list_id: @done_list.id, new_position: 1}
    @card1 = Card.find(@card1.id)
    assert_not_nil @card1.finished_at
  end

  test "should assign new member" do
    log_in_as users(:test_user1)
    assert_difference(['@card1.users.count', 'Notification.count']) do
      post '/addmember.json', params: { card_id: @card1.id, user_id: users(:test_user2).id }
    end
  end

  test "should not enroll same member twice" do
    log_in_as users(:test_user1)
    post '/addmember.json', params: { card_id: @card1.id, user_id: users(:test_user2).id }
    assert_no_difference('@card1.users.count') do
      post '/addmember.json', params: { card_id: @card1.id, user_id: users(:test_user2).id }
    end
  end
end
