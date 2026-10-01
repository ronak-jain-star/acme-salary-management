module Api
  module V1
    class EmployeesController < ApplicationController
      def index
        page = [params.fetch(:page, 1).to_i, 1].max
        per_page = [[params.fetch(:per_page, 25).to_i, 1].max, 100].min
        employees = Employee.includes(:current_salary).search(params[:q])
        employees = employees.where(country: params[:country]) if params[:country].present?
        employees = employees.where(department: params[:department]) if params[:department].present?
        total = employees.count
        render json: { employees: employees.order(:last_name, :first_name).offset((page - 1) * per_page).limit(per_page).map { |e| employee_json(e) }, page: page, per_page: per_page, total: total }
      end
      def show
        render json: employee_json(Employee.includes(:current_salary).find(params[:id]))
      end
      def salary_history
        render json: Employee.find(params[:id]).salary_changes.order(created_at: :desc).limit(100).map { |c| c.attributes.slice("id", "previous_amount_minor", "previous_currency", "new_amount_minor", "currency", "reason", "changed_by", "created_at") }
      end
      def create
        employee = Employee.find(params[:employee_id])
        input = params.require(:salary).permit(:amount_minor, :currency, :reason).to_h.symbolize_keys
        result = SalaryUpdater.call(employee: employee, **input, changed_by: params[:changed_by].presence || "HR Manager")
        if result.success?
          render json: { salary: { amount_minor: result.salary.amount_minor, currency: result.salary.currency }, change_id: result.change.id }, status: :created
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end
    end
  end
end
