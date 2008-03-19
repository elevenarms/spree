class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :variation

  validates_presence_of :product
  validates_numericality_of :quantity
  validates_numericality_of :price
  
  def self.from_cart_item(cart_item)
    line_item = self.new
    line_item.product = cart_item.product
    line_item.quantity = cart_item.quantity
    line_item.price = cart_item.price
    line_item.variation = cart_item.variation
    line_item
  end  
  
  def total
    self.price * self.quantity  
  end
  
end
