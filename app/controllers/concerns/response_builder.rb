# frozen_string_literal: true

module ResponseBuilder
  extend ActiveSupport::Concern

  def render_success(data: nil, metadata: nil, message: nil, status: :ok)
    render json: { data:, metadata:, message: }, status: status
  end

  def render_error(data: nil, message: nil, status: :internal_server_error, errors: {})
    render json: { data:, message:, errors: }, status: status
  end
end
