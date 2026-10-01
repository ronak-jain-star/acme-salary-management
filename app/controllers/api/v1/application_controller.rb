module Api
  module V1
    class ApplicationController < ActionController::API
      rescue_from ActiveRecord::RecordNotFound do
        render json: { error: "not found" }, status: :not_found
      end
      private
      def employee_json(employee)
        salary = employee.current_salary
        { id: employee.id, employee_number: employee.employee_number, name: "#{employee.first_name} #{employee.last_name}", email: employee.email, country: employee.country, department: employee.department, title: employee.title, salary: salary && { amount_minor: salary.amount_minor, currency: salary.currency } }
      end
    end
  end
end
