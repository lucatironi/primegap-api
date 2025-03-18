class CustomerPolicy < ApplicationPolicy
  attr_reader :user, :customer

  def initialize(user, customer)
    @user     = user
    @customer = customer
  end

  def index?
    user["company_id"].present?
  end

  def show?
    company?
  end

  def create?
    company?
  end

  def update?
    company?
  end

  def destroy?
    company?
  end

  class Scope < Scope
    def resolve
      scope.where(company_id: user["company_id"])
    end
  end

private

  def company?
    user["company_id"].present? && customer.company_id == user["company_id"]
  end
end
