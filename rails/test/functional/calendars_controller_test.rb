require "test_helper"

class Api::CalendarsControllerTest < ActionController::TestCase

  def setup
    stub_settings
    Settings.stubs(:slots).returns(build(:slots))
    @controller.stubs(:current_user).returns(build(:guest))
  end

  test "/calendar/:date should return json response" do
    get :show, { date: Date.today }
    assert_response :success
    assert_match "application/json", response.header['Content-Type']
    assert_match "#{Date.today}", response.body
  end

end