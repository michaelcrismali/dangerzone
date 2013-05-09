  private

  def current_user
    @current_user = User.find_by_id(session[:user_id]) || User.find_by_remember_token(cookies[:remember_token])
    request.remote_ip == @current_user.try(:sign_in_ip) ? @current_user : nil
  end

  def authorize_user
    redirect_to :sign_in unless current_user
  end
