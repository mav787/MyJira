require 'test_helper'

class BoardFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @board = boards(:one)
    @user = users(:one)
    @list = lists(:one)
  end

  fixtures :users
  fixtures :boards


    test "sign up and login" do

      get "/signup"
      assert_response :success
      post "/signup", params:{user:{name:@user.name, email:@user.email, password:@user.password, password_confirmation:@user.password}}
      assert_response :success

      get "/login"
      assert_response :success
    end

    test "update board" do
      patch board_url(@board), params: { board: { leader_id: @board.leader_id, name: @board.name } }
      assert_redirected_to board_url(@board)
    end



end
