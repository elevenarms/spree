class Coupon < ActiveRecord::Base
  has_many :discounts 
  
  validates_presence_of :calculator
  validates_presence_of :code
  
  def create_discount(checkout)
    return unless amount = calculator.constantize.calculate_discount(checkout)
    return if expires_at and Time.now > expires_at
    return if usage_limit and discounts.count >= usage_limit
    return unless checkout.discounts.empty? or (combine? and checkout.discounts.all? { |discount| discount.coupon.combine? })
    checkout.discounts.create(:coupon => self, :checkout => checkout, :amount => amount)
  end
end
