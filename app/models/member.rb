class Member < User

  # TODO: remove this once permissions/policies have been removed
  def admin?
    false
  end

end