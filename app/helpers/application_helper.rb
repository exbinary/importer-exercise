module ApplicationHelper

  def link_to_sign_in_or_out
    if user_signed_in?
      link_to('Log Out', destroy_user_session_path, :method => :delete)
    else
      link_to('Log In', new_user_session_path)
    end
  end

end
