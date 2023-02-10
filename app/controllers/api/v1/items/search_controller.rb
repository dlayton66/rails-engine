class Api::V1::Items::SearchController < BaseController
  rescue_from ItemParamsError, with: :item_params_error_response
  rescue_from ItemNotFoundError, with: :item_not_found_error_response
  rescue_from ItemMixedParamsError, with: :item_mixed_params_error_response
  rescue_from ItemNegativePriceError, with: :item_negative_price_error_response

  def index
    items = Item.search_all(params)
    render json: ItemSerializer.new(items)
  end

  private

    def item_params_error_response(exception)
      render json: ErrorSerializer.new(exception).serialize, status: :bad_request
    end

    def item_not_found_error_response
      render json: ErrorSerializer.new.item_serialize, status: :bad_request
    end

    def item_mixed_params_error_response(exception)
      render json: ErrorSerializer.new(exception).serialize, status: :bad_request
    end

    def item_negative_price_error_response(exception)
      render json: ErrorSerializer.new(exception).serialize, status: :bad_request
    end
end