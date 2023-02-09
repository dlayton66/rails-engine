class BaseController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid_response
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_response
  rescue_from MissingParamsError, with: :missing_params_error_response
  rescue_from EmptyParamsError, with: :empty_params_error_response

  def record_invalid_response(exception)
    render json: ErrorSerializer.new(exception).serialize, status: :bad_request
  end

  def record_not_found_response(exception)
    render json: ErrorSerializer.new(exception).serialize, status: :not_found
  end

  def missing_params_error_response(exception)
    render json: ErrorSerializer.new(exception).serialize, status: :bad_request
  end

  def empty_params_error_response(exception)
    render json: ErrorSerializer.new(exception).serialize, status: :bad_request
  end
end