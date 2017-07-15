class UserMailer < ActionMailer::Base
  default from: "info@halalgems.com"
  def send_direction(email,restaurant,text)
    @email = email
    @restaurant = restaurant
    @text = text
    mail(:to => email, :subject => "Direction to #{restaurant.name}")
  end

  def send_reject_review(email,review)
    @email = email
    @review = review
    mail(:to => email, :subject => "Your review (##{review.id}) is rejected!")
  end

  def send_keysearch_for_admin(keyword)
    email = "info@halalgems.com"
    @keyword = keyword
    mail(:to => email, :subject => "[Halalgems]No search result with the keyword #{keyword}")
  end

  def send_email_notify_expired_time(email,username)
    @email = email
    @username = username
    mail(:to => email, :subject => "[Halalgems] Your account are expired")
  end

  def share_restaurant_email to, from, subject, message, url
    @url = url
    @message = message
    mail(:to => to, :from => from,  :subject => subject)
  end

  def send_reject_restaurant_update email, restaurant, message = nil
    @email = email
    @restaurant = restaurant
    @message = message
    mail(:to => email, :subject => "Your restaurant (##{restaurant.id}) update is rejected!")
  end
  def send_reject_reply(email,review)
    @email = email
    @review = review
    mail(:to => email, :subject => "Your reply for (##{review.id}) is rejected!")
  end
  def send_contact_message(email,guest_name,guest_email,content)
    @email = email
    @guest_name = guest_name
    @guest_email = guest_email
    @content = content
    mail(:to => email, :subject => "Contact message - From #{guest_name}<#{guest_email}>")
  end
  def send_report_restaurant_message(email, user_email, restaurant_name, reasons, more_details)
    @email = email
    @user_email = user_email
    @restaurant_name = restaurant_name
    @reasons = reasons
    @more_details = more_details
    mail(:to => email, :subject => "Report restaurant message - From #{user_email}")
  end
  def send_advertise_restaurant_message(email, name, guest_email, restaurant_name, phone)
    @email            = email
    @name            = name
    @guest_email     = guest_email
    @restaurant_name = restaurant_name
    @phone           = phone
    mail(:to => email, :subject => "Advertise Restaurant - From #{name}<#{guest_email}>")
  end
  def share_restaurant_friend(username, friend_email, message, restaurant_link)
    @name  =  username
    @friend_email = friend_email
    @message = message
    @restaurant_link = restaurant_link
    mail(:to => friend_email, :subject => "Share restaurant from halalgems")
  end

  def send_email_restaurant(restaurant_email, message)
    @message = message
    @restaurant_email = restaurant_email
    mail(:to => restaurant_email, :subject => "Somebody contact with You")
  end

  def send_email_for_offer_reject(restaurant_email, message)
    @message = message
    @restaurant_email = restaurant_email
    mail(:to => @restaurant_email, :subject => "Your restaurant's offer has rejected by admin.")
  end

end
