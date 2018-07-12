class AuthController < ApplicationController
  include JsonWebToken
  
  def register
    user = User.new(login_params)

    if user.save
      cookie = jwt_cookie user
      response.set_cookie :access_token, cookie
      response.status = 204
    else
      response.status = 422
      return render json: { error: user.errors.full_messages }
    end

  end

  def login

    email_param = { email: login_params[:email] }
    user = User.find_for_authentication(email_param)
    password = login_params[:password]

    if user.nil?
      response.status = 400
      return render json: { error: 'Not Found' }
    end

    if user.valid_password? password
      cookie = jwt_cookie user
      response.set_cookie :access_token, cookie
      response.status = 204
    else
      response.status = 422
      render json: { error: 'Password invalid' }
    end
    
  end

  private 
  def login_params
    params.require(:auth).permit(:email, :password)
  end

end
