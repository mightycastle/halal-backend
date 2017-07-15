class Wordpress < ActiveRecord::Base
  establish_connection "wordpress-#{Rails.env}"
  self.table_name = "wp_users"
 	attr_accessible :user_login, :user_pass, :user_email, :display_name, :user_registered
  # ============================================================================
  # INSTANCE - ACTION
  # ============================================================================
  # def self.get_post_form_wordpress
  #   where(post_type: 'post', post_status: 'publish').order('post_date desc').limit(6)
  # end
  def self.create_gem_hunter_wordpress(user)
  	@user = Wordpress.where(user_login: user.username).last
  	if @user.blank?
	  	user =  Wordpress.new(
	  		user_login: user.username,
	  		user_pass: user.username,
	  		user_email: user.email,
	  		display_name: user.username,
	  		user_registered: Time.now
	  		)
	  	user.save
	  end

  end
end