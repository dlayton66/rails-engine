class Api::V1::Merchants::SearchController < BaseController
  rescue_from MerchantParamsError, with: :merchant_params_error_response
  rescue_from MerchantNotFoundError, with: :merchant_not_found_error_response

  def show
    merchant = Merchant.search(params)
    render json: MerchantSerializer.new(merchant)
  end

  private
  
    def merchant_params_error_response(exception)
      render json: ErrorSerializer.new(exception).serialize, status: :bad_request
    end

    def merchant_not_found_error_response
      render json: ErrorSerializer.new.merchant_serialize, status: :bad_request
    end
end