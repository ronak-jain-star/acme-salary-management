# frozen_string_literal: true

module Api
  module V1
    class InsightsController < ApplicationController
      def index
        groups = SalaryInsights.call(country: params[:country], department: params[:department])
        render_success(data: { groups: groups })
      end
    end
  end
end
