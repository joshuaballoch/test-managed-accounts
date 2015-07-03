class StripeManagedAccountCreator
  attr_accessor :errors

  def initialize(marina_name:, marina_external_id:)
    @marina_name = marina_name
    @marina_external_id = marina_external_id
  end

  # TODO: validate information before making stripe call
  def call
    if valid?
      stripe_account_details = Stripe::Account.create({
        business_name: marina_name,
        country: 'US',
        managed: true
      })
      StripeManagedAccount.create!(
        stripe_account_id: stripe_account_details["id"],
        stripe_secret_key: stripe_account_details["keys"]["secret"],
        stripe_publishable_key: stripe_account_details["keys"]["publishable"],
        marina_name: marina_name,
        marina_external_id: marina_external_id
      )
    end
  end

  private

  def valid?
    @errors = []
    check_if_required_info_present
    check_that_no_duplicate_account_exists
    @errors.length == 0
  end

  def check_if_required_info_present
    @errors << "Marina name can't be blank" unless marina_name.present?
    @errors << "Marina external id can't be blank" unless marina_external_id.present?
  end

  def check_that_no_duplicate_account_exists
    @errors << "Marina with this name or external id already has a managed account" unless StripeManagedAccount.where("marina_name = ? OR marina_external_id = ?", marina_name, marina_external_id).count == 0
  end

  attr_accessor :marina_name, :marina_external_id
end
