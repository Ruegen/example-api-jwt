class AuthController < ApplicationController
  include JsonWebTokens
  
  def register
    user = User.new(login_params)

    if user.save!
      cookie = jwt_cookie user
      response.set_cookie :access_token, cookie
      response.status = 204
    end

    rescue => e
      response.status = 422
      render json: { error: e.message }
  end

  def login

    email_param = { email: login_params[:email] }
    user = User.find_for_authentication(email_param)
    password = login_params[:password]

    if user.valid_password? password
      cookie = jwt_cookie user
      response.set_cookie :access_token, cookie
      response.status = 204
    end

  rescue => e
    response.status = 422
    render json: { error: e.message }
  end

  private 
  def login_params
    params.require(:auth).permit(:email, :password)
  end

end
