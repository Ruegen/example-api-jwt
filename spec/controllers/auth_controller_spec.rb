require 'rails_helper'
require 'jwt'

RSpec.describe AuthController, type: :controller do
  
  let(:password) {'12345678'}
  let(:secret) { ENV.fetch('JWT_SECRET')}
  let(:email) {'ruegen@example.com'}

  describe "#register" do
    
    context "user hasn't registered correctly" do 

      it "no token" do
        user = build(:user)

        post :register, params: {
          auth: {
            email: '', 
            password: ''
          }  
        }

        access_token = response.cookies['access_token']

        expect(response).to have_http_status(422)
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

      expect(response).to have_http_status(422)
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
