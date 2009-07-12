class CreateCoupons < ActiveRecord::Migration
  def self.up
    create_table :coupons do |t|
      t.string :code
      t.string :name
      t.string :description
      t.string :calculator
      t.integer :usage_limit
      t.boolean :combine
      t.datetime :expires_at
      t.timestamps
    end
  end

  def self.down
    drop_table :coupons
  end
end
