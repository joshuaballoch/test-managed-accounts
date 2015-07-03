class StripeManagedAccount < ActiveRecord::Base

  validates :stripe_account_id, :presence => true,
                                :uniqueness => true
  validates :marina_name, :presence => true,
                          :uniqueness => true
  validates :marina_external_id, :presence => true,
                                 :uniqueness => true
end
