require 'test_helper'

class ReplyReviewsControllerTest < ActionController::TestCase
  setup do
    @reply_review = reply_reviews(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reply_reviews)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reply_review" do
    assert_difference('ReplyReview.count') do
      post :create, reply_review: { content: @reply_review.content, review_id: @reply_review.review_id, user_id: @reply_review.user_id }
    end

    assert_redirected_to reply_review_path(assigns(:reply_review))
  end

  test "should show reply_review" do
    get :show, id: @reply_review
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @reply_review
    assert_response :success
  end

  test "should update reply_review" do
    put :update, id: @reply_review, reply_review: { content: @reply_review.content, review_id: @reply_review.review_id, user_id: @reply_review.user_id }
    assert_redirected_to reply_review_path(assigns(:reply_review))
  end

  test "should destroy reply_review" do
    assert_difference('ReplyReview.count', -1) do
      delete :destroy, id: @reply_review
    end

    assert_redirected_to reply_reviews_path
  end
end
