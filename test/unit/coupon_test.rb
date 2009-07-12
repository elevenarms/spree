require 'test_helper'

class CouponTest < ActiveSupport::TestCase
  should_validate_presence_of :code
  should_validate_presence_of :calculator
  
  context "instance" do
    setup do
      @checkout = Factory(:checkout)
      @coupon = Factory(:coupon)
    end
    context "create_discount" do
      setup do
        @discount = @coupon.create_discount(@checkout)
      end 
      should_change "@checkout.discounts.count", :by => 1
      should "create a discount with an amount determined by the calculator" do
        assert_equal BigDecimal.new("0.99"), @discount.amount
      end
      should_change "@checkout.order.credits.count", :by => 1
      should "create a credit with the amount determined by the calculator" do
        assert_equal BigDecimal.new("0.99"), @discount.credit.amount
      end
      context "with additional coupon" do
        setup { @additional_coupon = Factory(:coupon) }
        context "when existing coupon prohibits combination" do
          setup do
            @coupon.combine = false
            @additional_coupon.combine = true
            @additional_coupon.create_discount(@checkout)
          end
          should_not_change "Discount.count"
        end
        context "when additional coupon prohibits combination" do
          setup do
            @coupon.combine = true
            @additional_coupon.combine = false
            @additional_coupon.create_discount(@checkout)
          end
          should_not_change "Discount.count"
        end
        context "when both coupons allow combination" do
          setup do
            @coupon.combine = true
            @additional_coupon.combine = true
            @additional_coupon.create_discount(@checkout)
          end
          should_change "Discount.count", :by => 1
        end
      end
    end    
    context "when expired" do
      setup do 
        @coupon.expires_at = 3.days.ago
        @coupon.create_discount(@checkout)
      end
      should_not_change "Discount.count"
    end
    context "when usage_limit has been exceeded" do
      setup do
        @coupon.usage_limit = 0
        @coupon.create_discount(@checkout)
      end
      should_not_change "Discount.count"
    end
  end
end