require "test_helper"

class Api::CourtsControllerTest < ActionController::TestCase

  def setup
    stub_settings
    Settings.stubs(:slots).returns(build(:slots))
  end

  test "/courts/:date should return json response" do
    get :index, { date: Date.today }
    assert_response :success
    assert_match "application/json", response.header['Content-Type']
    assert_match "bollocks", response.body
  end

end