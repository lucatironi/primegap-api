require "rails_helper"

RSpec.describe CustomersController, type: :request do
  let!(:user) { User.create(email_address: "user@example.com", password: "password") }
  let(:jwt_token) { login_user_and_get_token(user.email_address, "password") }
  let(:headers) { { "Authorization" => "Bearer #{jwt_token}" } }

  # This should return the minimal set of attributes required to create a valid
  # Customer. As you add validations to Customer, be sure to
  # adjust the attributes here as well.
  let(:valid_params) do
    { customer: { full_name: "John Doe", email: "john.doe@example.com", phone: "123456789", company_id: 1 } }
  end

  let(:invalid_params) do
    { customer: { full_name: nil, email: "john.doe@example.com", phone: "123456789", company_id: 1 } }
  end

  describe "POST #create" do
    scenario "with valid attributes" do
      post "/customers", headers: headers, params: valid_params

      expect(response).to have_http_status(:created)
    end
  end

  describe "GET #index" do
    it "assigns all customers as @customers" do
      get "/customers", headers: headers

      expect(response).to have_http_status(:ok)
    end
  end
end