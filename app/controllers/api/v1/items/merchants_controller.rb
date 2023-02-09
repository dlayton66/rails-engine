class Api::V1::Items::MerchantsController < BaseController
  def show
    @item = Item.find(params[:item_id])
    render json: MerchantSerializer.new(@item.merchant)
  end
end