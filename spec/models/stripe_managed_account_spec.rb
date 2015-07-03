require 'rails_helper'

describe StripeManagedAccount do

  it "requires stripe_account_id to be present" do
    new_account = new_validated_account_with_attrs(stripe_account_id: "")
    expect(new_account.errors.to_a).to include("Stripe account can't be blank")
  end

  it "requires marina_name to be unique" do
    create_managed_account(stripe_account_id: "stap123")
    new_account = new_validated_account_with_attrs(stripe_account_id: "stap123")
    expect(new_account.errors.to_a).to include("Stripe account has already been taken")
  end


  it "requires marina_name to be present" do
    new_account = new_validated_account_with_attrs(marina_name: "")
    expect(new_account.errors.to_a).to include("Marina name can't be blank")
  end

  it "requires marina_name to be unique" do
    create_managed_account(marina_name: "Jimmy's Marina")
    new_account = new_validated_account_with_attrs(marina_name: "Jimmy's Marina")
    expect(new_account.errors.to_a).to include("Marina name has already been taken")
  end

  it "requires marina_external_id to be present" do
    new_account = new_validated_account_with_attrs(marina_external_id: "")
    expect(new_account.errors.to_a).to include("Marina external can't be blank")
  end

  it "requires marina_external_id to be unique" do
    create_managed_account(marina_external_id: "aadf123")
    new_account = new_validated_account_with_attrs(marina_external_id: "aadf123")
    expect(new_account.errors.to_a).to include("Marina external has already been taken")
  end

  def new_validated_account_with_attrs(attrs)
    new_account = StripeManagedAccount.new(attrs)
    new_account.valid?
    new_account
  end

  def create_managed_account(options)
    manual_account = StripeManagedAccount.new(options)
    manual_account.save(validate: false)
  end
end
