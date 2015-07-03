require 'rails_helper'

describe StripeManagedAccountCreator do
  let(:validation_error) { ActiveRecord::RecordInvalid }

  let(:creator) do
    StripeManagedAccountCreator.new(marina_name: "Jimmy's Marina", marina_external_id: "lkj123")
  end

  before do
    # Stub Stripe API. Otherwise every test run will create a new account!
    @stripe_stubbed_response = {
      "id" => SecureRandom.hex(10),
      "keys" => {
        "secret" => SecureRandom.hex(10),
        "publishable" => SecureRandom.hex(10),
      }
    }

    allow(Stripe::Account).to receive(:create) { @stripe_stubbed_response }
  end

  it "creates a new StripeManagedAccount" do
    expect{ creator.call }.to change(StripeManagedAccount, :count).by(1)
  end

  it "gets and saves the stripe account id" do
    created_account = creator.call
    expect(created_account.stripe_account_id).to eq @stripe_stubbed_response["id"]
    expect(created_account.stripe_secret_key).to eq @stripe_stubbed_response["keys"]["secret"]
    expect(created_account.stripe_publishable_key).to eq @stripe_stubbed_response["keys"]["publishable"]
  end

  it "saves the marina name" do
    created_account = creator.call
    expect(created_account.marina_name).to eq "Jimmy's Marina"
  end

  it "saves the marina external_id" do
    created_account = creator.call
    expect(created_account.marina_external_id).to eq "lkj123"
  end

  it "does not call Stripe if marina external id missing" do
    expect(Stripe::Account).not_to receive :create
    service = described_class.new(marina_name: "any name", marina_external_id: "")
    service.call
  end

  it "does not call Stripe if marina name missing" do
    expect(Stripe::Account).not_to receive :create
    service = described_class.new(marina_name: "", marina_external_id: "any01")
    service.call
  end

  it "does not call Stripe if marina name already taken" do
    expect(Stripe::Account).not_to receive :create
    create_managed_account(marina_name: "Dup Marina")
    service = described_class.new(marina_name: "Dup Marina", marina_external_id: "any01")
    service.call
  end

  it "does not call Stripe if marina external id already taken" do
    expect(Stripe::Account).not_to receive :create
    create_managed_account(marina_external_id: "any01")
    service = described_class.new(marina_name: "Dup Marina", marina_external_id: "any01")
    service.call
  end

  def create_managed_account(options)
    manual_account = StripeManagedAccount.new(options)
    manual_account.save(validate: false)
  end
end
