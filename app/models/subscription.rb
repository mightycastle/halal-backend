class Subscription < ActiveRecord::Base
  include ApplicationHelper

  # ============================================================================
  # ATTRIBUTES
  # ============================================================================
  attr_accessible :action, :amount, :authorization, :card_expires_on, :card_type, :first_name,
                  :ip_address, :last_name, :message, :params, :success, :user_id, :plan_id, :paypal_status, :expire_time

  attr_accessible :card_number, :card_verification, :express_token

  serialize          :params
  # ============================================================================
  # ENUM
  # ============================================================================
  STATUS = {inactive: 0, active: 1, expired: 2}
  CONVERT_STATUS = {'0' => 'inactive', '1' => 'active', '2' => 'expired'}
  RANSACKABLE_ATTRIBUTES = ["amount", "paypal_status", "created_at"]
  SUBSCRIPTION_TYPE = {annually: 1, monthly: 2 }

  # ============================================================================
  # ASSOCIATIONS
  # ============================================================================
  belongs_to         :user
  belongs_to         :plan
  has_many           :transactions

  # ============================================================================
  # SCOPE
  # ============================================================================
  scope :subs_success, where(success: true)
  scope :active, where("expire_time > ? AND paypal_status =  ?", Time.now, Subscription::STATUS[:active])

  # ============================================================================
  # INSTANCE - ACTION
  # ============================================================================
  def self.ransackable_attributes auth_object = nil
    super & RANSACKABLE_ATTRIBUTES
  end

  # function to check and update subscription when expired time
  def self.check_and_update_scription_expire_time
    to_date = Time.now.to_date
    subscriptions = Subscription.where(expire_time: to_date, paypal_status: Subscription::STATUS[:active])
    if subscriptions.length > 0
      subscriptions.each do |sub|
        if sub.profile_id.nil?
          sub.set_expired
          sub.send_email_notification
        else
          response = EXPRESS_GATEWAY.status_recurring(sub.profile_id)
          if response.params['profile_status'] == 'ActiveProfile'
            sub.update_expire_time
          else
            sub.set_expired
            sub.send_email_notification
          end
        end
      end
    end
  end


  # ============================================================================
  # CLASS - ACTION
  # ============================================================================

  def is_expired?
    paypal_status == Subscription::STATUS[:expired]
  end

  def is_active_now?
    if self.expire_time
      self.expire_time > Time.now.to_date && self.paypal_status == Subscription::STATUS[:active]
    end
  end

  def is_recurring?
    recurring_status
  end

  def send_email_notification
    to_user = self.user.email
    username = self.user.username
    UserMailer.send_email_notify_expired_time(to_user, username).deliver
  end

  def set_expired
    self.update_column('paypal_status', Subscription::STATUS[:expired])
    self.update_column('expire_time', Time.now.to_date)
  end

  def setup_purchase(return_url, cancel_return_url)
    EXPRESS_GATEWAY.setup_authorization(price_in_format,
      ip: ip_address,
      return_url: return_url,
      cancel_return_url: cancel_return_url,
      notify_url: full_url('/paypal/notify'),
      subtotal: price_in_format,
      tax: price_in_format,
      currency: 'GBP',
      no_shipping: 1,
      billing_agreement: {
        type: 'RecurringPayments',
        description: "Subscribe HalalGems with #{plan.name}"
        },
      description: "Subscribe HalalGems with #{plan.name}",
      items: [
        {
          name: plan.name,
          description: "Subscribe HalalGems with #{plan.name}" ,
          amount: price_in_format,
          quantity: 1
        }
      ]
    )
  end

  def update_expire_time
    m = plan.plan_type.number_of_months if plan && plan.plan_type
    if m
        time_set = Time.now + (m.to_i).month
        self.expire_time = time_set.to_date
    end
    self.save
  end

  # def cancel_curring(profile_id)
  #   ppr = PayPal::Recurring.new(:profile_id => profile_id)
  #   response = ppr.suspend
  # end

  def cancel_curring
    response = EXPRESS_GATEWAY.cancel_recurring(profile_id, note: 'Stop subscription')
    response
  end

  def renew_curring(profile_id)
    ppr = PayPal::Recurring.new(:profile_id => profile_id)
    response = ppr.reactivate
  end

  def express_token=(token)
    write_attribute(:express_token, token)

    # if new_record? && !token.blank?
    if token.present?
      ppr = PayPal::Recurring.new(:token => token)
      details = ppr.checkout_details
      self.express_payer_id = details.payer_id
      self.first_name       = details.first_name
      self.last_name        = details.last_name
      self.amount           = details.amount
    end
  end

  def to_format(price)
    (price*100).round
  end

  def price_in_format
    to_format amount
  end

  def status
    if self.success
      CONVERT_STATUS["#{self.paypal_status}"]
    else
      "Failed"
    end
  end

  def next_payment
    self.expire_time
  end

  def process_purchase
    if express_token
      authorize_response = EXPRESS_GATEWAY.authorize(price_in_format, express_purchase_options)
      create_transaction authorize_response
      response = EXPRESS_GATEWAY.recurring(price_in_format, nil, express_purchase_options)
      logger = Logger.new('log/paypal_notification.log')
      logger.info "price_in_format #{price_in_format}"
      logger.info "express_purchase_options #{express_purchase_options}"
      update_subscription response
      response
    end
  end

  def express_purchase_options
    {
      token: express_token,
      amount: amount.to_f.round(2),
      currency: 'GBP',
      ipn_url: full_url('/paypal/notify'),
      notify_url: full_url('/paypal/notify'),
      ip: ip_address,
      payer_id: express_payer_id,
      period: paypal_period,
      frequency: frequency,
      start_date: Time.zone.now,
      description: "Subscribe HalalGems with #{plan.name}"
    }
  end

  def frequency
    1
  end

  def paypal_period
    if plan && plan.plan_type_id == Subscription::SUBSCRIPTION_TYPE[:annually]
      'Year'
    else
      'Month'
    end
  end

  def update_subscription (response)
    self.success       = response.success?
    self.profile_id = response.params['profile_id']
    self.save
  rescue ActiveMerchant::ActiveMerchantError => e
    self.success       = false
    self.save
  end

  def create_transaction response
    transaction_id = response.params['transaction_id']
    if transaction_id
      transaction = self.transactions.build(
        transaction_id: transaction_id ,
        amount: self.amount,
        transaction_data: response.params
      )
      transaction.save
    end
  end

end
