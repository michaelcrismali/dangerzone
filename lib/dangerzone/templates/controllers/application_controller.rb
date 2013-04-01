  def current_user
    @current_user = User.find_by_remember_token(cookies[:remember_token])
    @current_user ||= User.find_by_id(session[:user_id])
    @current_user = nil if @current_user && request.remote_ip != @current_user.sign_in_ip
    @current_user
  end

  def authorize_user
    redirect_to sign_in_url if current_user.nil?
  end

