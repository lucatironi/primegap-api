require "rails_helper"

RSpec.describe SessionsController, type: :request do
  let!(:user) { User.create(email_address: "user@example.com", password: "password") }

  let(:valid_params) do
    { email_address: user.email_address, password: "password" }
  end

  let(:invalid_params) do
    { email_address: user.email_address, password: "not-the-right-password" }
  end

  before do
    allow(JWT).to receive(:encode).and_return("jwt-secret-token")
  end

  describe "POST #create" do
    scenario "with valid credentials" do
      post "/sessions", params: valid_params

      expect(response).to have_http_status(:ok)
      expect(parsed_json).to eq("token" => "jwt-secret-token")
    end

    it "creates a new session for user" do
      expect do
        post "/sessions", params: valid_params
      end.to change(user.sessions, :count).by(1)
    end

    scenario "with invalid credentials" do
      post "/sessions", params: invalid_params

      expect(response).to have_http_status(:unauthorized)
      expect(parsed_json).to eq("error" => "Invalid email or password")
    end
  end
end
