# frozen_string_literal: true

module Api
  module V1
    class EmployeesController < ApplicationController
      def index
        result = EmployeeDirectory.call(
          page: params.fetch(:page, 1),
          per_page: params.fetch(:per_page, 25),
          query: params[:q],
          country: params[:country],
          department: params[:department]
        )

        render_success(
          data: { employees: EmployeeBlueprint.render_as_hash(result.employees) },
          metadata: { page: result.page, per_page: result.per_page, total: result.total }
        )
      end

      def show
        render_success(data: EmployeeBlueprint.render_as_hash(Employee.includes(:current_salary).find(params[:id])))
      end

      def salary_history
        changes = Employee.find(params[:id]).salary_changes.order(created_at: :desc).limit(100)
        render_success(data: SalaryChangeBlueprint.render_as_hash(changes))
      end

      def create
        employee = Employee.find(params[:employee_id])
        input = params.require(:salary).permit(:amount_minor, :currency, :reason).to_h.symbolize_keys
        result = SalaryUpdater.call(employee: employee, **input,
changed_by: params[:changed_by].presence || 'HR Manager')
        if result.success?
          render_success(
            data: { salary: CurrentSalaryBlueprint.render_as_hash(result.salary), change_id: result.change.id },
            status: :created
          )
        else
          render_error(errors: result.errors, status: :unprocessable_entity)
        end
      end
    end
  end
end
