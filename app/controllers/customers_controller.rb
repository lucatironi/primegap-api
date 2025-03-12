class CustomersController < ApplicationController
  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      render json: @customer, status: :created, location: @customer
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  def index
    @customers = Customer.all

    render json: @customers
  end

  private

  def customer_params
    params.require(:customer).permit(:full_name, :email, :phone, :company_id)
  end
end
