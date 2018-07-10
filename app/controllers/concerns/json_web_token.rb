require 'jwt'
module JsonWebToken

    def jwt_cookie user
        secret = ENV.fetch('JWT_SECRET')

        payload = {
            email: user.email
        }

        token = JWT.encode(payload, secret)

        return {
            value: token,
            expires: 30.minutes.from_now,
            domain: 'localhost:3000',
            httponly: true
        }
    end
end