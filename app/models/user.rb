  class User < ApplicationRecord

     has_many :expenses
     has_many :user_payment

     validates_presence_of :name
     validates_presence_of :email
     validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
     validates_presence_of :cost_of_meal
     scope :enable_users, -> { where(enable: true) }
   end
 





