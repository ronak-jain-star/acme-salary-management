# frozen_string_literal: true

class EmployeeBlueprint < Blueprinter::Base
  identifier :id

  fields :employee_number, :email, :country, :department, :title

  field :name do |employee|
    [ employee.first_name, employee.last_name ].join(' ')
  end

  field :salary do |employee|
    CurrentSalaryBlueprint.render_as_hash(employee.current_salary) if employee.current_salary
  end
end
