require 'rails_helper'
require 'jwt'

RSpec.describe AuthController, type: :controller do
  
  let(:password) {'12345678'}
  let(:secret) { ENV.fetch('JWT_SECRET')}

  describe "#login " do 

    it "#does not create jwt cookie" do 
    
      user = build(:user)

      post :login, params: {
        auth: {
          email: user.email, 
          password: password
        }
      }
      access_token = response.cookies['access_token']

      expect(response).to have_http_status(422)
      expect(access_token).to eq(nil)
    end


    it "creates jwt in cookie" do

      user = create(:user)

      post :login, params: {
        auth: {
          email: user.email, 
          password: password
        }
      }
      
      payload = {
        email: user.email
      }
      
      token = JWT.encode payload, secret

      access_token = response.cookies['access_token']

      expect(response).to be_successful
      expect(access_token).to eq(token)
      
      
    end

  end


end
