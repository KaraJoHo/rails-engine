class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def render_unprocessable_entity_response(exception)
    render json: ErrorSerializer.bad_params(exception.record.errors), status: 404
  end

  def render_not_found_response(exception)
    render json: {error: exception.message, message: "your query could not be completed" }, status: :not_found 
  end
end
