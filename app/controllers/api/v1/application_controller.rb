# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API
      include ResponseBuilder

      rescue_from ActiveRecord::RecordNotFound do
        render_error(message: 'not found', status: :not_found)
      end
    end
  end
end
