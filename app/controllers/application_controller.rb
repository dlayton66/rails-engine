class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid_response

  def record_invalid_response(exception)
    render json: ErrorSerializer.new(exception).serialize, status: :bad_request
  end
end
