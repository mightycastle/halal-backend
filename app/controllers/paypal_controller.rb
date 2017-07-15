class PaypalController < ApplicationController
  include ActiveMerchant::Billing::Integrations

  def notify
    response = PayPal::Recurring::Notification.new(params)
    logger = Logger.new('log/paypal_notification.log')
    logger.info response.as_json
    if response.verified?
      subscription = Subscription.find_by_profile_id(response.payment_id)
      logger.info "response.profile_statusresponse.profile_status #{response.profile_status}"
      if subscription
        case response.profile_status
        when 'Pending'
          subscription.paypal_status = Subscription::STATUS[:inactive]
        when 'Active'
          subscription.update_column('paypal_status', Subscription::STATUS[:active])
          next_payment_date = DateTime.strptime(response.params[:next_payment_date],"%H:%M:%S %b %e, %Y %Z").to_date
          time_created = DateTime.strptime(response.params[:time_created],"%H:%M:%S %b %e, %Y %Z").to_date
          if response.params[:next_payment_date] && next_payment_date > time_created
            subscription.update_column('expire_time', next_payment_date)
          else
            subscription.update_expire_time
          end
          if response.transaction_id
            transaction = subscription.transactions.find_by_transaction_id(response.transaction_id)
            if transaction
              if response.params[:next_payment_date] && next_payment_date > time_created
                transaction.update_column('next_billing_cycle', DateTime.strptime(response.params[:next_payment_date],"%H:%M:%S %b %e, %Y %Z"))
              else
                transaction.update_next_billing_cycle(subscription.plan_id)
              end
              transaction.update_column('transaction_status', Transaction::STATUS[:active])
            else
              transaction = subscription.transactions.build(
                transaction_id: response.transaction_id,
                amount: subscription.amount,
                transaction_data: response.params,
                transaction_status: Transaction::STATUS[:active]
              )
              transaction.update_next_billing_cycle(subscription.plan_id)
              transaction.save
            end
          end

        when 'Cancelled'
          subscription.recurring_status = false
        when 'Expired'
          subscription.paypal_status = Subscription::STATUS[:expired]
        end
        subscription.save
      end
    end
    render :nothing => true
  end
end