class Api::V1::MerchantsController < ApplicationController
  def index
    # render json: Merchant.all
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    get_merchant
    render json: MerchantSerializer.new(@merchant)
  end

  private

    def get_merchant
      @merchant = Merchant.find(params[:id])
    end
end