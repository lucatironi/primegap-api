require "rails_helper"

RSpec.describe CustomersController, type: :request do
  let!(:user) { User.create(email_address: "user@example.com", password: "password") }
  let(:jwt_token) { login_user_and_get_token(user.email_address, "password") }
  let(:headers) { { "Authorization" => "Bearer #{jwt_token}" } }

  # This should return the minimal set of attributes required to create a valid
  # Customer. As you add validations to Customer, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { full_name: "John Doe", email: "john.doe@example.com", phone: "123456789", company_id: 1 }
  end

  let(:invalid_attributes) do
    { full_name: nil, email: "john.doe@example.com", phone: "123456789", company_id: 1 }
  end

  let!(:customer) { Customer.create(valid_attributes) }

  describe "GET #index" do
    it "assigns all customers as @customers" do
      get "/customers", headers: headers

      expect(response).to have_http_status(200)
      expect(parsed_json[0]["id"]).to eq(customer.id)
    end
  end

  describe "GET #show" do
    scenario "with existing customer" do
      get "/customers/#{customer.id}", headers: headers

      expect(response).to have_http_status(200)
      expect(parsed_json["id"]).not_to be_nil
      expect(parsed_json["full_name"]).to eq("John Doe")
      expect(parsed_json["first_name"]).to eq("John")
      expect(parsed_json["last_name"]).to eq("Doe")
      expect(parsed_json["email"]).to eq("john.doe@example.com")
      expect(parsed_json["phone"]).to eq("123456789")
      expect(parsed_json["company_id"]).to eq(1)
      expect(parsed_json["created_at"]).not_to be_nil
      expect(parsed_json["updated_at"]).not_to be_nil
    end

    scenario "with non existing customer" do
      get "/customers/not-an-id", headers: headers

      expect(response).to have_http_status(404)
      expect(parsed_json).to be_blank
    end
  end

  describe "POST #create" do
    scenario "with valid params" do
      post "/customers", headers: headers, params: { customer: valid_attributes }

      expect(response).to have_http_status(201)
      expect(parsed_json["id"]).not_to be_nil
      expect(parsed_json["full_name"]).to eq("John Doe")
      expect(parsed_json["first_name"]).to eq("John")
      expect(parsed_json["last_name"]).to eq("Doe")
      expect(parsed_json["email"]).to eq("john.doe@example.com")
      expect(parsed_json["phone"]).to eq("123456789")
      expect(parsed_json["company_id"]).to eq(1)
      expect(parsed_json["created_at"]).not_to be_nil
      expect(parsed_json["updated_at"]).not_to be_nil
    end

    scenario "with invalid params" do
      post "/customers", headers: headers, params: { customer: invalid_attributes }

      expect(response).to have_http_status(422)
      expect(parsed_json).to eq("full_name" => [ "can't be blank" ])
    end
  end

  describe "PATCH #update" do
    scenario "with valid params" do
      patch "/customers/#{customer.id}", headers: headers, params: { customer: { full_name: "John F. Doe", email: "john.f.doe@example.com" } }

      expect(response).to have_http_status(204)

      customer.reload
      expect(customer.full_name).to eq("John F. Doe")
      expect(customer.first_name).to eq("John F.")
      expect(customer.last_name).to eq("Doe")
      expect(customer.email).to eq("john.f.doe@example.com")
    end

    scenario "with invalid params" do
      patch "/customers/#{customer.id}", headers: headers, params: { customer: { full_name: nil } }

      expect(response).to have_http_status(422)
      expect(parsed_json).to eq("full_name" => [ "can't be blank" ])
    end
  end


  describe "DELETE #destroy" do
    scenario "with existing customer" do
      delete "/customers/#{customer.id}", headers: headers

      expect(response).to have_http_status(204)
      expect { Customer.find(customer.id) }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
