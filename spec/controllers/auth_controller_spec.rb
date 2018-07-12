require 'rails_helper'
require 'jwt'

RSpec.describe AuthController, type: :controller do
  
  let(:password) {'12345678'}
  let(:secret) { ENV.fetch('JWT_SECRET')}
  let(:email) {'ruegen@example.com'}


  describe "#jwt_cookie" do 

    it "generates a jwt in hash" do
      user = build(:user)
      controller = AuthController.new
      expected = "eyJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6InJ1ZWdlbkBleGFtcGxlLmNvbSJ9.AeAnIwMaj1GHrB7ZLP985gHLkoosQlL5gayPkAgGcwI"
      cookie = controller.instance_eval{jwt_cookie(user)}
      result = cookie[:value]
      expect(result).to eq(expected)
    end

  end

  describe "#register" do
    
    context "user hasn't registered correctly" do 

      it "will fail to register user without email" do
        post :register, params: {
          auth: {
            email: '', 
            password: ''
          }
        }
        expect(response).to have_http_status(422)
      end

      it "will not generate a jwt token when it fails" do 
        post :register, params: {
          auth: {
            email: '', 
            password: ''
          }
        }
        access_token = response.cookies['access_token']
        expect(access_token).to eq(nil)
      end

    end


    it "returns a token" do 

      post :register, params: {
        auth: {
          email: email, 
          password: password
        }  
      }

      payload = {
        email: email
      }
      
      token = JWT.encode payload, secret

      access_token = response.cookies['access_token']

      expect(response).to be_successful
      expect(access_token).to eq(token)

    end


  end


  describe "#login" do 

    context "user has not been registerd" do
      it "#does not create jwt cookie" do 
    
      user = build(:user)

      post :login, params: {
        auth: {
          email: user.email, 
          password: password
        }
      }
      access_token = response.cookies['access_token']

      expect(response).to have_http_status(400)
      expect(access_token).to eq(nil)
    end

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
