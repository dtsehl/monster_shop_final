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

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    if @discount.update(discount_params)
      flash[:notice] = "Discount Updated"
      redirect_to "/merchant/discounts/#{@discount.id}"
    else
      flash[:error] = @discount.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def discount_params
    params.require(:discount).permit(:name, :min_item_quantity, :percent_off)
  end
end
