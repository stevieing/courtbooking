require "test_helper"

class Api::CourtsControllerTest < ActionController::TestCase

  def setup
    stub_settings
    @controller.stubs(:current_user).returns(build(:guest))
  end

  test "/courts/:date should return a json response" do
    get :show, { date: Date.today }
    assert_response :success
    assert_match("application/json", response.header['Content-Type'])
    assert_match(/courts/, response.body)
  end

end