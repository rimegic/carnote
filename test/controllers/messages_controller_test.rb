require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @conversation = conversations(:one)
    sign_in @user
  end

  test "should create message" do
    assert_difference("Message.count") do
      post conversation_messages_url(@conversation), params: { message: { body: "Test message" } }
    end
    assert_redirected_to conversation_path(@conversation)
  end
end
