require 'test_helper'

class BoardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @board = boards(:one)
  end

  test "should get index" do
    get boards_url
    assert_response :success
  end

  test "should not get new when not logged_in" do
    get new_board_url
    assert_redirected_to root_url
  end

  test "should create board when logged in" do
    log_in_as users(:test_user1)
    assert_difference('Board.count') do
      post boards_url, params: { board: { leader_id: @board.leader_id, name: @board.name } }
    end
    assert_redirected_to board_url(Board.last)
  end

  test "should not create board when not logged in" do
    assert_no_difference('Board.count') do
      post boards_url, params: { board: { leader_id: @board.leader_id, name: @board.name } }
    end
    assert_redirected_to root_path
  end

  test "should show board when belonged to board" do
    log_in_as users(:test_user1)
    get board_url(@board)
    assert_response :success
  end

  test "should not show board when not logged in" do
    get board_url(@board)
    assert_redirected_to root_path
  end

  test "should not show board when not belonged to board" do
    log_in_as users(:test_user2)
    get board_url(@board)
    assert_redirected_to root_path
  end

  test "should update board when belong to board" do
    log_in_as users(:test_user1)
    patch board_url(@board), params: { board: { leader_id: @board.leader_id, name: @board.name } }
    assert_redirected_to board_url(@board)
  end

  test "should not update board when not belong to board" do
    log_in_as users(:test_user2)
    patch board_url(@board), params: { board: { leader_id: @board.leader_id, name: @board.name } }
    assert_redirected_to root_path
  end

  test "should enroll new member if belong to board" do
    log_in_as users(:test_user1)
    assert_difference("@board.users.count") do
      get enroll_url, params: { board: @board.id, user: users(:test_user2).id }
    end
  end

  test "should not enroll same member twice" do
    log_in_as users(:test_user1)
    get enroll_url, params: { board: @board.id, user: users(:test_user2).id }
    assert_no_difference("@board.users.count") do
      get enroll_url, params: { board: @board.id, user: users(:test_user2).id }
    end
  end
end
