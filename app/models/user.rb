  class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

     has_many :expenses
     has_many :user_payment

     validates_presence_of :name
     validates_presence_of :email
     validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
     # validates_presence_of :cost_of_meal
     scope :active_users, -> { where(enable: true) }
   end
 





