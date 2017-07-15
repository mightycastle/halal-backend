class SubscriptionsController < ApplicationController
  layout 'admin', :only  => ['admin_subscriptions']
  before_filter :required_user_login
  def index
    @plan = Plan.all
    @subscriptions = Subscription.all
  end

  def express
    if params['plan']
      plan_id = params['plan'].to_i
      session[:plan_id] = plan_id
      plan = Plan.find_by_id(plan_id)
      plan_type = PlanType.find_by_id(plan.plan_type_id)

      total_price = plan.amount*plan_type.number_of_months
      @subscription = Subscription.new(
        ip_address: request.remote_ip,
        amount: total_price,
        plan_id: plan_id
      )
      redirect_to EXPRESS_GATEWAY.redirect_url_for(
        @subscription.setup_purchase(new_subscription_url, subscriptions_url).token)
    else
      redirect_to :back
    end

  end

  # GET /subscriptions/new
  # GET /subscriptions/new.json
  def new
    if session[:plan_id]
      plan_id = session[:plan_id]
      @plan = Plan.find_by_id(plan_id)
    end
    redirect_to become_a_member_path unless params[:token]
    @subscription = Subscription.new(:express_token => params[:token])
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    if session[:plan_id]
      plan_id = session[:plan_id]
      session[:plan_id] = nil
      plan = Plan.find_by_id(plan_id)
      plan_type = PlanType.find_by_id(plan.plan_type_id)
      total_price = plan.amount*plan_type.number_of_months
      params[:subscription][:plan_id] = plan_id
      express_token = params[:subscription][:express_token]
      subscription_olds = current_user.subscriptions.active
      if subscription_olds.length > 0
        subscription_olds.each do |sub|
          sub.set_expired
          sub.cancel_curring
        end
      end
      @subscription = current_user.subscriptions.build(params[:subscription])
      @subscription.paypal_status = Subscription::STATUS[:inactive]
      @subscription.ip_address = request.remote_ip
      if @subscription.save
        if @subscription.process_purchase
          if current_user.is_restaurant_owner_role? && current_user.restaurants.length > 0
            redirect_to restaurant_info_path(current_user.restaurants.first.slug)
          else
            render :action => "success"
          end
        else
          @subscription.update_column('paypal_status', Subscription::STATUS[:inactive])
          render :action => "failure"
        end
      else
        render :action => 'new'
      end
    else
      render :action => "failure"
    end
  end



  def cancel_curring
    @subscription = Subscription.find(params[:id])
    if @subscription.profile_id.present?
      @response = @subscription.cancel_curring
      if @response.success?
        @subscription.update_attribute('recurring_status', false)
      end
      @response
    end
    respond_to do |format|
        format.js
    end
  end

  def renew_curring
    @subscription = Subscription.find(params[:id])
    if @subscription.profile_id
      @response = @subscription.renew_curring(@subscription.profile_id)

      @subscription.update_attribute('recurring_status', true) if @response.success?

      @response
    end
    respond_to do |format|
        format.js
    end
  end

  def admin_subscriptions
    @search = Subscription.search(params[:q])
    @subscriptions = @search.result.order("created_at DESC").page(params[:page])
    respond_to do |format|
      format.html
    end
  end
end

