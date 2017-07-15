class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin_role, :boolean
    
    #create admin user
#    user = User.new
#    user.email = "admin@nexlesoft.com"
#    user.password = "123456"
#    user.admin_role = true
#    user.save!
#    user.confirmation_token = nil
#    user.username = 'adminnexle'
#    user.first_name = 'Admin'
#    user.last_name = 'Nexle'
#    user.status = 'verified'

#    user.save!
  end
end
