class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid_response
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_response

  def record_invalid_response(exception)
    render json: ErrorSerializer.new(exception).serialize, status: :bad_request
  end

  def record_not_found_response(exception)
    render json: ErrorSerializer.new(exception).serialize, status: :not_found
  end
end
