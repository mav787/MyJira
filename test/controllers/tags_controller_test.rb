require 'test_helper'

class TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @card = cards(:todo_card1)
    @tag = tags(:one)
  end

  test "should bind tag" do
    assert_difference('@card.tags.count') do
      post '/tag/bind.json', params: { tag_id: @tag.id, card_id: @card.id }
    end
  end

  test "should not bind same tag twice" do
    post '/tag/bind.json', params: { tag_id: @tag.id, card_id: @card.id }
    assert_no_difference('@card.tags.count') do
      post '/tag/bind.json', params: { tag_id: @tag.id, card_id: @card.id }
    end
  end

  test "should unbind tag" do
    post '/tag/bind.json', params: { tag_id: @tag.id, card_id: @card.id }
    assert_difference('@card.tags.count', -1) do
      post '/tag/unbind.json', params: { tag_id: @tag.id, card_id: @card.id }
    end
  end
end
