module Api
  module V1
    class InsightsController < ApplicationController
      def index
        employees = Employee.joins(:current_salary)
        employees = employees.where(country: params[:country]) if params[:country].present?
        employees = employees.where(department: params[:department]) if params[:department].present?
        groups = employees.joins(:current_salary)
          .select("employees.country, employees.department, current_salaries.currency, COUNT(*) AS headcount, ROUND(AVG(current_salaries.amount_minor)) AS average_minor, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY current_salaries.amount_minor) AS median_minor, MIN(current_salaries.amount_minor) AS min_minor, MAX(current_salaries.amount_minor) AS max_minor")
          .group("employees.country", "employees.department", "current_salaries.currency")
          .map { |row| { country: row.country, department: row.department, currency: row.currency, headcount: row.read_attribute(:headcount), average_minor: row.read_attribute(:average_minor).to_i, median_minor: row.read_attribute(:median_minor).round, min_minor: row.read_attribute(:min_minor), max_minor: row.read_attribute(:max_minor) } }
        render_success(data: { groups: groups })
      end
    end
  end
end
