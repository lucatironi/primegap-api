class CustomersController < ApplicationController
  before_action :set_customer, only: [ :show, :update, :destroy ]

  def index
    authorize Customer
    @customers = policy_scope(Customer)

    render json: @customers
  end

  def show
    render json: @customer
  end

  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      render json: @customer, status: :created, location: @customer
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  def update
    if @customer.update(customer_params)
      head :no_content
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @customer.destroy

    head :no_content
  end

private

  def set_customer
    @customer = Customer.find(params[:id])
    authorize @customer
  end

  def customer_params
    params.require(:customer).permit(:full_name, :email, :phone, :company_id)
  end
end
