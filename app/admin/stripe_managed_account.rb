ActiveAdmin.register StripeManagedAccount do
  permit_params :marina_external_id, :marina_name

  index do
    id_column
    column :marina_name
    column :marina_external_id
    column :stripe_account_id
  end

  show do
    h4 "Dockwa Account Data"
    attributes_table do
      row :marina_name
      row :marina_external_id
    end

    h4 "Linked Stripe Account Data"

    h5 "TODO: list bank info etc down here - work on the update action first though"

    active_admin_comments
  end

  sidebar "Stripe Account Summary", only: :show do
    render partial: "stripe_account_verification_details", locals: { stripe_account_info: stripe_account_info }
  end

  form do |f|
    inputs 'Marina Info - TBD but this should pull from the main app as a search or something' do
      input :marina_external_id
      input :marina_name
    end
    actions
    panel 'Notes' do
      "Clicking 'create' below will create a Stripe Managed Account with country set to U.S.
       You can add banking and other info afterward."
    end
  end

  controller do

    def create
      service = StripeManagedAccountCreator.new(
        marina_name: params[:stripe_managed_account][:marina_name],
        marina_external_id: params[:stripe_managed_account][:marina_external_id]
      )

      if new_account = service.call
        flash.notice = "Stripe Managed Account Created"
        redirect_to admin_stripe_managed_account_path new_account
      else
        flash.alert = service.errors.join(", ")
        redirect_to new_admin_stripe_managed_account_path
      end
    end

    def show
      account = StripeManagedAccount.find(params[:id])
      @stripe_account_info = Stripe::Account.retrieve(account.stripe_account_id)
      super
    end

  end
end
