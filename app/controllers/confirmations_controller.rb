class ConfirmationsController < Devise::ConfirmationsController
  def new
    super
  end

  def create
    super
  end

  def show
    params[:join_mailing_list] = true
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_navigational_format?
      sign_in(resource_name, resource)
      #change status for user after activate account
      resource.update_attribute(:status, "verified")
      #add user's email to mailchimp
      begin
        # resource.add_to_mailchimp_list("#{Devise.mailing_list_name}")
      rescue
      ensure
        respond_with_navigational(resource){ redirect_to root_path }        
      end
    else
      respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :new }
    end
  end
end
