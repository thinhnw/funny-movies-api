module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected
    def find_verified_user
      token = cookies.to_hash["token"]
      reject_unauthorized_connection unless token
      begin
        decoded_token = JWT.decode(
          token,
          ENV["DEVISE_JWT_SECRET_KEY"],
          true,
          { algorithm: "HS256" }
        )
        user_id = decoded_token.first["sub"]
        User.find(user_id)
      rescue
        reject_unauthorized_connection
      end
    end
  end
end
