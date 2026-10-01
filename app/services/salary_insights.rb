# frozen_string_literal: true

class SalaryInsights
  GROUP_COLUMNS = %w[employees.country employees.department current_salaries.currency].freeze
  AGGREGATE_COLUMNS = <<~SQL.squish.freeze
    employees.country,
    employees.department,
    current_salaries.currency,
    COUNT(*) AS headcount,
    ROUND(AVG(current_salaries.amount_minor)) AS average_minor,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY current_salaries.amount_minor) AS median_minor,
    MIN(current_salaries.amount_minor) AS min_minor,
    MAX(current_salaries.amount_minor) AS max_minor
  SQL

  def self.call(country: nil, department: nil)
    new(country:, department:).call
  end

  def initialize(country:, department:)
    @country = country
    @department = department
  end

  def call
    grouped_salary_rows.map { |row| serialize_group(row) }
  end

  private

  def grouped_salary_rows
    employees = Employee.all
    employees = employees.where(country: @country) if @country.present?
    employees = employees.where(department: @department) if @department.present?

    employees.joins(:current_salary)
      .select(AGGREGATE_COLUMNS)
      .group(*GROUP_COLUMNS)
  end

  def serialize_group(row)
    {
      country: row.country,
      department: row.department,
      currency: row.currency,
      headcount: row.read_attribute(:headcount),
      average_minor: row.read_attribute(:average_minor).to_i,
      median_minor: row.read_attribute(:median_minor).round,
      min_minor: row.read_attribute(:min_minor),
      max_minor: row.read_attribute(:max_minor)
    }
  end
end
