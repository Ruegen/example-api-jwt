class AuthController < ApplicationController
  include JsonWebToken
  
  def register
    user = User.new(login_params)

    if user.save!
      cookie = jwt_cookie user
      response.set_cookie :access_token, cookie
      response.status = 204
    end

  end

  def login

    email_param = { email: login_params[:email] }
    user = User.find_for_authentication(email_param)
    password = login_params[:password]

    if user.nil?
      respond_to do |format|
        format.json { render json: { error: 'Not Found' }, status: 400 }
      end
    end

    if user.valid_password? password
      cookie = jwt_cookie user
      response.set_cookie :access_token, cookie
      response.status = 204
    else
      render json: { error: 'Password invalid' }, status: 422
    end
    
  end

  private 
  def login_params
    params.require(:auth).permit(:email, :password)
  end

end
