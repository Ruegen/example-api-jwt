require 'rails_helper'

describe JsonWebToken do
    let(:secret) { ENV.fetch('JWT_SECRET')}

    context "module jwt_cookie method" do
        include JsonWebToken
        
        it "should return a valid token" do 
            user = build(:user)
            cookie = jwt_cookie user
            result = cookie[:value]
            expected = JWT.encode({email: user.email}, secret)
            expect(result).to eq(expected)
        end

        it "should raise error with empty user obj" do 
            user = {}
            error_message = "undefined method `email' for {}:Hash"
            expect{jwt_cookie(user)}.to raise_error(NoMethodError, error_message)
        end

        it "should raise argument error with no user obj" do
            expect{jwt_cookie}.to raise_error(ArgumentError)
        end
        
    end
end