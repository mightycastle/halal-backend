FactoryGirl.define do
  factory :review, :class => Review do  |f|    
    f.restaurant_id 0
    f.user_id 0

    f.title "Review #{Time.now.to_i}"
    f.content "COntent review #{Time.now.to_i}"
    f.service 5
    f.quality 5
    f.value 5
    f.status true
    f.rating 5
    f.created_at Time.now
    f.updated_at Time.now
    f.visited_date Time.now
    # f.terms_conditions true
    f.feature_review false
    f.feature_review_set_at Time.now
    f.reply_content ""
    f.user_reply 0
    f.approve_reply false
    f.reply_time nil
  end
end