# NOTE: just shimming this class in here for now
#       need to find the right abstraction (LATER)
class StripeFormObject

  attr_reader :stripe_managed_account, :stripe_account_info

  def initialize(stripe_managed_account:, stripe_account_info:)
    @stripe_managed_account = stripe_managed_account
    @stripe_account_info = stripe_account_info
  end

  def self.model_name
    StripeManagedAccount.model_name
  end

  delegate :persisted?, :new_record?, :to => :stripe_managed_account
  delegate :marina_name, :marina_external_id, :to => :stripe_managed_account

  delegate :business_name, :to => :stripe_account_info

end
