module RequestSpecHelper
  def parsed_json
    JSON.parse(response.body)
  end

  def login_user_and_get_token(email_address, password)
    post "/sessions", params: { email_address: email_address, password: password }
    sleep 1.seconds
    parsed_json["token"]
  end
end
