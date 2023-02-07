class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    get_merchant
    render json: ItemSerializer.new(@merchant.items)
  end

  private

    def get_merchant
      @merchant = Merchant.find(params[:merchant_id])
    end
end