ActiveAdmin.register StripeManagedAccount do
  permit_params :marina_external_id, :marina_name

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

  end
end
