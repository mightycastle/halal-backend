require 'spec_helper'
require "rails_helper"  
# require 'pry'
describe SubscriptionsController, :type => :controller do  
  context "POST create" do  

    before do  
      user = create(:user, admin_role: true)
      sign_in user
      ActiveMerchant::Billing::Base.mode = :test  
      ActiveMerchant::Billing::Integrations::Paypal::Notification.any_instance.stub(:acknowledge).and_return(true)  
      user = create(:user)
      
      # @subscription = create(:subscription,    
          # paypal_status: 0)
      transaction = create(:transaction) 
      
      plan_type = create(:plan_type)
      @plan = create(:plan, plan_type_id: plan_type.id)
      session[:plan_id] = @plan.id
      total_price = @plan.amount*plan_type.number_of_months
      subscription = Subscription.new(
          ip_address: request.remote_ip,
          amount: total_price,
          plan_id: @plan.id
        )
      @express_token = subscription.setup_purchase(new_subscription_url, subscriptions_url).token
      @subscription = Subscription.new(:express_token => @express_token)
      @subscription_params = {
        plan_id: @plan.id,
        express_token: @express_token
      }
    end

    it "Check valid token with paypal" do 
      token = 'express_token'
      ppr = PayPal::Recurring.new(:token => @express_token)
      details = ppr.checkout_details
      expect(details.success?).to eq(true)
    end

    it "Check invalid token" do 
      token = 'express_token'
      ppr = PayPal::Recurring.new(:token => token)
      details = ppr.checkout_details
      expect(details.success?).to eq(false)
    end

    it "Create subscription with valid params" do 
      post 'create' , subscription: @subscription_params
      @subscription =  Subscription.last
      expect(@subscription.amount).not_to eq(nil)  
      expect(@subscription.paypal_status).to eq(Subscription::STATUS[:inactive])  
      expect(@subscription.transaction).to eq(nil)
    end
  end  
end  

# https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-8C069461TX919761T
