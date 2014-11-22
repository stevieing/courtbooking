require "test_helper"

class Api::CourtsControllerTest < ActionController::TestCase

  def setup
    stub_settings
    Settings.stubs(:slots).returns(build(:slots))
    @controller.stubs(:current_user).returns(build(:guest))
  end

  test "/courts/:date should return json response" do
    get :show, { date: Date.today }
    assert_response :success
    assert_match "application/json", response.header['Content-Type']
    assert_match "#{Date.today.to_s(:uk)}", response.body
  end

end