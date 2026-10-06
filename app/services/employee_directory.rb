# frozen_string_literal: true

class EmployeeDirectory
  Result = Struct.new(:employees, :page, :per_page, :total, keyword_init: true)

  def self.call(page: 1, per_page: 25, query: nil, country: nil, department: nil)
    page = [ page.to_i, 1 ].max
    per_page = [ [ per_page.to_i, 1 ].max, 100 ].min

    employees = Employee.includes(:current_salary).search(query)
    employees = employees.where(country: country) if country.present?
    employees = employees.where(department: department) if department.present?
    total = employees.count
    pagination = Pagy.new(count: total, page: page, limit: per_page)
    results = employees.order(:last_name, :first_name)
      .offset(pagination.offset)
      .limit(pagination.limit)

    Result.new(
      employees: results,
      page: pagination.page,
      per_page: pagination.limit,
      total: pagination.count
    )
  end
end
