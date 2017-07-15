ActionMailer::Base.delivery_method = :smtp

##SMTP google
#ActionMailer::Base.smtp_settings = {
#  :address              => "smtp.gmail.com",
#  :port                 => "587",
#  :domain               => "gmail.com",
#  :user_name            => "tuanbdnexlesoft@gmail.com",
#  :password             => "1qazxsw2123456",
#  :authentication       => "plain",
#  :enable_starttls_auto => true
#}

#ActionMailer::Base.smtp_settings = {
#  :address   => "smtp.mandrillapp.com",
#  :port      => 25,
#  :user_name => "tuanbui" #ENV["MANDRILL_USERNAME"],
#  :password  => "cefacb55b3c9e838a048c3e82ff84b85-us5"  #ENV["MANDRILL_API_KEY"]
#}

#Config send mail from mailchimp: tuanbui

#ActionMailer::Base.smtp_settings = {
#  :address              => "smtp.mandrillapp.com",
#  :port                 => "587",
#  :domain               => "localhost:3000",
#  :user_name            => "tuanbui",
#  :password             => "23a30c6f-8023-4cd2-82f1-900b6f433af2",
#  :authentication       => "plain",
#  :enable_starttls_auto => true
#}

#Config send mail from mailchimp: zkhaku

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.mandrillapp.com",
  :port                 => "587",
  :domain               => "staging.halalgems.com", #"halalgems.com",
  :user_name            => "zkhaku",
  :password             => ENV["SMTP_EMAIL_PASSWORD"],
  :authentication       => "plain",
  :enable_starttls_auto => true
}


