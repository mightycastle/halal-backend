class Review < ActiveRecord::Base
  include Grape::Entity::DSL

  # ============================================================================
  # BEFORE ACTION
  # ============================================================================
  #ajaxful_rater
  #ajaxful_rateable :stars => 10, :dimensions => [:service, :quility, :value]
  #acts_as_rateable
  after_create :everage_rating
  after_create :satisfied_calc
  # after_update :update_restaurant_avg_rating

  # ============================================================================
  # ATTRIBUTES
  # ============================================================================

  attr_accessible :content, :quality, :rating, :restaurant_id, :service, :satisfied, :owner_has_read,
                  :status, :title, :user_id, :value, :visited_date, :terms_conditions, :feature_review, :feature_review_set_at,
                  :reply_content, :user_reply, :reply_time

  # ============================================================================
  # ASSOCIATIONS
  # ============================================================================
  belongs_to :user
  belongs_to :restaurant
  # has_many :projects
  # accepts_nested_attributes_for :projects

  # ============================================================================
  # SCOPE
  # ============================================================================
  scope :approved, where(:status => true)
  scope :un_review , where(:status => nil)
  scope :unapprove_reply, where("reply_content IS NOT NULL AND approve_reply IS NULL")
  scope :review_reply, where("reply_content IS NOT NULL ")
  scope :featured,     joins(:restaurant).where('restaurants.disabled = ? and feature_review = ?', false, true)

  scope :all_reviews,   where('content is not null')
  scope :all_ratings, where('content is     null')
  scope :satisfied_ratings, where('satisfied is true')

  # ============================================================================
  # VALIDATIONS
  # ============================================================================
  # validates :content,  :presence=>true

  validates_inclusion_of :service, :in => 1..5 , message: I18n.t("errors.invalid_rating_service")
  validates_inclusion_of :quality, :in => 1..5 , message: I18n.t("errors.invalid_rating_quality")
  validates_inclusion_of :value,   :in => 1..5 , message: I18n.t("errors.invalid_rating_value")

  validates :content, :length => { :maximum => 5000 }
  validates :terms_conditions, :acceptance => {:accept => true}

  # ============================================================================
  # ENUM
  # ============================================================================
  #Define status for approve/reject reviews
  STATUS = %w[1 0]
  SORT_BY = {most_recent: "created_at DESC", overall: "rating DESC", service: "service DESC", quality: "quality DESC", value: "value DESC"}
  # Setup searchable attributes for user model
  RANSACKABLE_ATTRIBUTES = ["content", "approve_reply", "created_at", 'reply_content', 'status', 'reply_time', 'feature_review']



  # ============================================================================
  # ENTITY
  # ============================================================================

  entity do
    expose :lambda_id, as: :id,
      if: lambda { |restaurant, options| true } do |restaurant, options|
        restaurant.id.to_s || ""
      end

    expose :lambda_content, as: :content,
      if: lambda { |review, options| true } do |review, options|
        review.content.to_s || ""
      end
    expose :lambda_service, as: :service,
      if: lambda { |review, options| true } do |review, options|
        review.service.to_s || ""
      end
    expose :lambda_quality, as: :quality,
      if: lambda { |review, options| true } do |review, options|
        review.quality.to_s || ""
      end
    expose :lambda_value, as: :value,
      if: lambda { |review, options| true } do |review, options|
        review.value.to_s || ""
      end
    expose :lambda_status, as: :status,
      if: lambda { |review, options| true } do |review, options|
        review.status.to_s || ""
      end
    expose :lambda_rating, as: :rating,
      if: lambda { |review, options| true } do |review, options|
        review.rating.to_s || ""
      end
    expose :lambda_user, as: :user,
      if: lambda { |review, options| true } do |review, options|
        review.user ? review.user.username : "None"
      end
    expose :lambda_restaurant, as: :restaurant,
      if: lambda { |review, options| options[:latest].blank? || options[:latest] == false } do |review, options|
        Restaurant::Entity.represent(review.restaurant, review_list: true)
      end
    expose :is_rating?
  end
  # ============================================================================
  # INSTANCE - ACTION
  # ============================================================================
  def self.ransackable_attributes auth_object = nil
    super & RANSACKABLE_ATTRIBUTES
  end

  def self.get_feature_review_home
    self.featured.order('feature_review_set_at DESC').limit(3)
  end

  def self.get_lastest_gem_hunter(limit)
    gem_hunters = User.where(gem_hunter: true).limit(limit)
    feature_reviews = []
    gem_hunters.each do |gem_hunter|
      feature_reviews.push(gem_hunter.reviews.first) if gem_hunter.reviews.present?
    end

    feature_reviews
    # Review.approved.joins(:user).where("users.gem_hunter IS TRUE").order("created_at DESC").limit(limit)
  end

  def self.update_rating_for_all_reviews
    Review.all.each do |rev|
      rev.service = 0.0 if rev.service.nil?
      rev.quality = 0.0 if rev.quality.nil?
      rev.value = 0.0 if rev.value.nil?
      rev.everage_rating
    end
  end
  # ============================================================================
  # CLASS - ACTION
  # ============================================================================
  def month_ago
    helpers.time_ago_in_words(created_at) << " ago"
  end

  def time_replied
    helpers.time_ago_in_words(reply_time) << " ago"
  end

  def helpers
    ActionController::Base.helpers
  end

  def everage_rating
    self.service = 0 if self.service.blank?
    self.quality = 0 if self.quality.blank?
    self.value = 0 if self.value.blank?
    self.rating = (self.service + self.quality + self.value )/3.0
    self.save
  end

  def satisfied_calc
    self.satisfied = (self.service + self.quality + self.value)/3.0 >= 3
    self.save
  end

  def rating
    r = read_attribute(:rating)
    r = r.round(1)
    i = r - r.floor
    case
    when i <= 0.25
      r.floor
    when i >= 0.75
      r.ceil
    else
      r.floor + 0.5
    end
  end

  def change_status(status)
    if Review::STATUS.include?(status.to_s)
      self.status = status
      self.save
      self.restaurant.update_rating
    else
      false
    end
  end

  def change_approve_reply(status)
    if Review::STATUS.include?(status.to_s)
      self.approve_reply = status
      self.save
      self.restaurant.update_rating
    else
      false
    end
  end

  def update_restaurant_avg_rating
    self.restaurant.update_rating
  end

  # ============================================================================
  # CLASS - CHECK
  # ============================================================================
  def is_featured?
    feature_review
  end

  def is_approved_reply?
    approve_reply == true
  end

  def is_show?(current_user)
    current_user.present? && self.restaurant && self.restaurant.user && current_user.id == self.restaurant.user.id
  end

  ###
  # Manager
  ###

  def is_rating?
    !self.content
  end

end
