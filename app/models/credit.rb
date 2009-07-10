class Credit < ActiveRecord::Base
  belongs_to :order
  acts_as_list :scope => :order 
  
  validates_presence_of :amount
  validates_numericality_of :amount
  validates_presence_of :description
end
