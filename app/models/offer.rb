class Offer < ActiveRecord::Base

  # ============================================================================
  # ATTRIBUTES
  # ============================================================================
  attr_accessible :restaurant_id, :offer_content, :time_available, :time_start_offer, :is_onetime,
   :start_date, :end_date, :start_time, :end_time, :date_publish, :time_publish, :approve, :reject, :image
  image_accessor  :image

  # ============================================================================
  # ASSOCIATIONS
  # ============================================================================
  belongs_to :restaurant


  # ============================================================================
  # SCOPE
  # ============================================================================
  scope :approved, where(approve: true)


  # ============================================================================
  # CLASS - ACTION
  # ============================================================================
  def get_time_valilable
    if is_recurring?
      if self.time_available && self.time_available.strip.present?
        time_available == 'All the time' ? 'Every day' : time_available
      else
        start_time_offer = [Schedule::DAY_SHEET["#{start_date}"], Schedule::DAY_SHEET["#{end_date}"]].join('-')
        end_time_offer = [
                          Schedule::TIME_SHEET["#{start_time}"].downcase.delete(' ').sub(':00', ''),
                          Schedule::TIME_SHEET["#{end_time}"].downcase.delete(' ').sub(':00', '')
                         ].join('-')
        [start_time_offer, end_time_offer].join(' ')
      end
    else
      end_time_offer = [
                        Schedule::TIME_SHEET["#{start_time}"].downcase.delete(' ').sub(':00', ''),
                        Schedule::TIME_SHEET["#{end_time}"].downcase.delete(' ').sub(':00', '')
                       ].join('-')

      [time_start_offer, end_time_offer].join(", ")
    end
  end

  def get_time_publish
    if self.time_start_offer && !self.time_start_offer.blank?
      t = DateTime.parse(time_start_offer)
      t.strftime("%d-%m-%Y")
    else
      [date_publish, Schedule::TIME_SHEET["#{time_publish}"]].join('-')
    end
  end

  def is_recurring?
    return !self.is_onetime
  end
end
