require "rails_helper"

RSpec.describe "health_check", type: :request do
  describe "GET health status" do
    before { get "/up" }

    it { expect(response).to have_http_status(200) }
  end
end
