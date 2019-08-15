class RegistrationsController < Devise::RegistrationsController

  before_action :configure_permitted_parameters, if: :devise_controller?


  #
  # create
  #
  def create
    super
  end

  #
  # new
  #
  def new
    super
  end

  protected

  #
  # after_update_path_for
  #
  def after_update_path_for(resource)
    account_settings_path
  end

  #
  # configure_permitted_parameters
  #
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email_confirmation])
  end

  #
  # after_sign_up_path_for
  #
  def after_sign_up_path_for(resource)
    set_brand_profile_name
    current_user.set_source rescue nil

    expenses_path
  end

  private

  #
  # check_captcha
  #
  def check_captcha
    unless verify_recaptcha
      self.resource = resource_class.new sign_up_params

      flash[:error] = "Invalid Captcha"
      respond_with_navigational(resource) { render :new }
    end
  end

  #
  # set_api_client
  #
  def set_api_client
    @api_client = ApiClient.find_by(api_key: params[:api_key]) rescue nil
  end

  #
  # set_deal
  #
  def set_deal
    @deal = Deal.find_by(id: params[:deal_id]) rescue nil
  end

  #
  # set_deal_id_and_parent_user_id
  #
  def set_deal_id_and_parent_user_id
    parent_user_id = nil
    deal_id = nil

    if @api_client.present? && @api_client.user_id == params[:partner_id].to_i
      parent_user_id = @api_client.user_id

    elsif @deal.present? && @deal.id_token_valid?(params[:id_token])
      parent_user_id = @deal.user_id
      deal_id = @deal.id
    end

    session[params[:controller].to_sym] ||= {}
    session[:omniauth_callbacks] ||= {}

    session[params[:controller].to_sym][:parent_user_id] ||= parent_user_id
    session[params[:controller].to_sym][:deal_id] ||= deal_id
    session[:omniauth_callbacks][:parent_user_id] ||= parent_user_id
    session[:omniauth_callbacks][:deal_id] ||= deal_id
  end

  #
  # set_brand_profile_name
  #
  def set_brand_profile_name
    user_name = params[:user][:name]

    agent_brand_profile = current_user.get_primary_agent_brand_profile
    agent_brand_profile ||= AgentBrandProfile.new(user_id: current_user.id)

    agent_brand_profile.name = user_name if agent_brand_profile.name.blank?
    agent_brand_profile.save(validate: false)
  rescue
    # Should fail silently
  end

end