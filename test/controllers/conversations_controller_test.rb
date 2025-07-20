require "test_helper"

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @other_user = users(:two)
    @conversation = conversations(:one)
    sign_in @user
  end

  test "should get index" do
    get conversations_url
    assert_response :success
  end

  test "should create conversation" do
    assert_difference('Conversation.count') do
      post conversations_url, params: { sender_id: @user.id, recipient_id: @other_user.id }
    end
    assert_redirected_to conversation_path(Conversation.last)
  end

  test "should show conversation" do
    get conversation_url(@conversation)
    assert_response :success
  end
end
