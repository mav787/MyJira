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
      post cards_url, params: { card: { content: @card.content, deadline: @card.deadline, list_id: @card.list_id } }
    end
    assert_redirected_to board_url(Card.last.list.board)
  end

  test "should show card" do
    get card_url(@card)
    assert_response :success
  end

  test "should get edit" do
    get edit_card_url(@card)
    assert_response :success
  end

  test "should update card" do
    patch card_url(@card), params: { card: { content: @card.content, deadline: @card.deadline, list_id: @card.list_id } }
    assert_redirected_to card_url(@card)
  end

  test "should destroy card" do
    assert_difference('Card.count', -1) do
      delete card_url(@card)
    end

    assert_redirected_to cards_url
  end
end
