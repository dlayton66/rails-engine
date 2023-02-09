class Api::V1::Merchants::SearchController < ApplicationController
  def show
    merchant = Merchant.find_first_merchant(params[:name])
    if merchant
      render json: MerchantSerializer.new(merchant)
    else
      render json: ErrorSerializer.new.merchant_serialize, status: :bad_request
    end
  end
end