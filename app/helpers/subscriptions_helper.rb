module SubscriptionsHelper


  def link_to_action_purchase subscription
    if subscription.is_active_now?
      if subscription.is_recurring?
        link_to ' ' + t('my_purchase.cancel_recurring'), cancel_curring_subscription_path(subscription), method: 'post', remote: true, class: 'btn btn-mini btn-danger fa fa-times-circle btn-color-white'

      elsif !subscription.is_recurring?
        link_to ' ' +t('my_purchase.enable_recurring'), renew_curring_subscription_path(subscription), method: 'post', remote: true, class: 'btn btn-mini btn-success fa fa-check-circle btn-color-white'

      end
    end
  end

  def check_text_confirm plan_type_id = nil
    unless plan_type_id.blank?
      plan_type = PlanType.find_by_id(plan_type_id)
      if plan_type.number_of_months == 1
        'month'
      elsif plan_type.number_of_months == 12
        'year'
      end
    end

  end
end
