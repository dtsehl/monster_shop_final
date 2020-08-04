class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :order_discounts
  has_many :orders, through: :order_discounts

  validates_presence_of :name

  validates_numericality_of :min_item_quantity, greater_than: 0
  validates_numericality_of :percent_off, greater_than: 0, less_than: 100
end
