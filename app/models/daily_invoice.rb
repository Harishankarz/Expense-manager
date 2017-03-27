  class DailyInvoice < ApplicationRecord
    has_many :expenses, :dependent => :destroy
    #belongs_to :user
    validates_presence_of :restaurant_name
    validates_presence_of :amount
    validates_presence_of :date
    has_attached_file :image
    validates_attachment :image, :content_type => { :content_type => ["image/jpeg","image/jpg","image/gif","image/png","image/pdf"] }
    accepts_nested_attributes_for :expenses
    acts_as_paranoid
  end
