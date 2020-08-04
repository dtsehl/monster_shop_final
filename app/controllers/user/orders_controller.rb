class User::OrdersController < ApplicationController
  before_action :exclude_admin

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    @order = current_user.orders.new
    @order.save
    if any_discounts?
      order_discounts_creation
      discounted_order_items_creation
    else
      order_items_creation
    end
    session.delete(:cart)
    flash[:notice] = "Order created successfully!"
    redirect_to '/profile/orders'
  end

  def cancel
    order = current_user.orders.find(params[:id])
    order.cancel
    redirect_to "/profile/orders/#{order.id}"
  end

  def order_discounts_creation
    discounts = []
    cart.items.each do |item|
      discounts << item.merchant.discounts.where('min_item_quantity <= ?', cart.count_of(item.id)).max
    end
    discounts.each do |discount|
      @order.order_discounts.create(discount_id: discount.id)
    end
  end

  def discounted_order_items_creation
    cart.items.each do |item|
      @order.order_items.create({
        item: item,
        quantity: cart.count_of(item.id),
        price: cart.discounted_subtotal(item.id) / cart.count_of(item.id)
        })
    end
  end

  def order_items_creation
    cart.items.each do |item|
      @order.order_items.create({
        item: item,
        quantity: cart.count_of(item.id),
        price: item.price
        })
    end
  end

  def any_discounts?
    cart.items.any? { |item| item.discount_application }
  end
end
