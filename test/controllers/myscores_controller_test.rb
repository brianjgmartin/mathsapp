require 'test_helper'

class MyscoresControllerTest < ActionController::TestCase
  setup do
    @myscore = myscores(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:myscores)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create myscore" do
    assert_difference('Myscore.count') do
      post :create, myscore: { answer: @myscore.answer, level: @myscore.level, profile_id: @myscore.profile_id, question: @myscore.question, result: @myscore.result, score: @myscore.score }
    end

    assert_redirected_to myscore_path(assigns(:myscore))
  end

  test "should show myscore" do
    get :show, id: @myscore
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @myscore
    assert_response :success
  end

  test "should update myscore" do
    patch :update, id: @myscore, myscore: { answer: @myscore.answer, level: @myscore.level, profile_id: @myscore.profile_id, question: @myscore.question, result: @myscore.result, score: @myscore.score }
    assert_redirected_to myscore_path(assigns(:myscore))
  end

  test "should destroy myscore" do
    assert_difference('Myscore.count', -1) do
      delete :destroy, id: @myscore
    end

    assert_redirected_to myscores_path
  end
end
