class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
    @discount = Discount.new
  end

  def create
    merchant = current_user.merchant
    @discount = merchant.discounts.create(discount_params)
    if @discount.save
      flash[:notice] = "Discount Created"
      redirect_to "/merchant/discounts"
    else
      flash[:error] = @discount.errors.full_messages.to_sentence
      redirect_to request.referrer
    end
  end

  private

  def discount_params
    params.require(:discount).permit(:name, :min_item_quantity, :percent_off)
  end
end
