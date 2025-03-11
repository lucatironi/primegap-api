require "rails_helper"

RSpec.describe SessionsController, type: :request do
  let!(:user) { User.create(email_address: "user@example.com", password: "password") }

  let(:valid_params) do
    { email_address: user.email_address, password: "password" }
  end

  let(:invalid_params) do
    { email_address: user.email_address, password: "not-the-right-password" }
  end

  let(:parsed_response) { JSON.parse(response.body) }

  before do
    allow(JWT).to receive(:encode).and_return("jwt-secret-token")
  end

  describe "POST #create" do
    context "with valid credentials" do
      before { post "/sessions", params: valid_params }

      it { expect(response).to have_http_status(:ok) }
      it { expect(parsed_response).to eq("token" => "jwt-secret-token") }
    end

    context "with invalid credentials" do
      before { post "/sessions", params: invalid_params }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(parsed_response).to eq("error" => "Invalid email or password") }
    end
  end
end
