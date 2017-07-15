class Transaction < ActiveRecord::Base
  include ApplicationHelper
  # ============================================================================
  # ASSOCIATION
  # ============================================================================ 
  belongs_to    :subscription

  # ============================================================================
  # ATTRIBUTES
  # ============================================================================   
  attr_accessible :transaction_id, :transaction_data, :amount, :next_billing_cycle, :transaction_status


  # ============================================================================
  # ENUM
  # ============================================================================ 
  STATUS = {inactive: 0, active: 1, expired: 2, suspend: 3, cancel: 4, pending: 5}


  # ============================================================================
  # CLASS - ACTION
  # ============================================================================ 
  def update_next_billing_cycle plan_id
    plan = Plan.find_by_id(plan_id)
    if plan 
      m =  plan.plan_type.number_of_months if plan.plan_type
      if m && m == 1
        self.next_billing_cycle =  Time.now + 1.month
      elsif m && m == 12
        self.next_billing_cycle =  Time.now + 1.year
      end
    end
    self.save
  end
end
