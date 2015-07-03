class CreateStripeManagedAccounts < ActiveRecord::Migration
  def change
    create_table :stripe_managed_accounts do |t|
      t.string :marina_external_id
      t.string :marina_name
      t.string :stripe_account_id
      # TODO: Decide whether to keep these. Only needed for auth..
      t.string :stripe_secret_key
      t.string :stripe_publishable_key

      t.timestamps null: false
    end

    add_index :stripe_managed_accounts, :marina_name, :unique => true
    add_index :stripe_managed_accounts, :marina_external_id, :unique => true
    add_index :stripe_managed_accounts, :stripe_account_id, :unique => true
  end
end
