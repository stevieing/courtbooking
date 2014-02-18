module AuthenticationHelpers
  
  def create_current_user(user)
    @current_user = user
  end
  
  def create_standard_user
    user = create(:user)
    add_standard_permissions(user)
    user
  end
  
  def current_user
    @current_user = create_standard_user if @current_user.nil?
    @current_user
  end
  
  def create_user(username, admin = false, mail_me = true)
    create(:user, username: username, admin: admin, mail_me: mail_me)
  end
  
  def opponent
    @opponent ||= create_user("WorthyOpponent")
  end
  
  def other_member
    @other_member ||= create_user("OtherMember")
  end
  
  def sign_in(user)
    visit sign_in_path
    fill_in "Username", with: user.username
    fill_in "Password", with: user.password
    click_button "sign in"
  end
  
  def add_user_permission(permission)
    current_user.permissions.create(allowed_action_id: AllowedAction.find_by(name: permission).id)
  end
  
end

World(AuthenticationHelpers)