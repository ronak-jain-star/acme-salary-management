# frozen_string_literal: true

require 'csv'

class DemoDataSeed
  RANDOM_SEED = 20_260_001
  DATA_DIRECTORY = File.expand_path('../../db/data', __dir__).freeze
  DEPARTMENTS = %w[Engineering People Finance Sales Operations Product Design].freeze
  LEVELS = %w[Associate Senior Lead Staff Manager].freeze
  ROLES = {
    'Engineering' => 'Engineer',
    'People' => 'People Partner',
    'Finance' => 'Finance Analyst',
    'Sales' => 'Sales Representative',
    'Operations' => 'Operations Specialist',
    'Product' => 'Product Specialist',
    'Design' => 'Designer'
  }.freeze
  COUNTRIES = CSV.read(
    File.join(DATA_DIRECTORY, 'demo_countries.csv'), headers: true, converters: :numeric
  ).map { |row| row.to_h.transform_keys(&:to_sym).freeze }.freeze
  FIRST_NAMES = CSV.read(
    File.join(DATA_DIRECTORY, 'demo_first_names.csv'), headers: true
  ).map { |row| row.fetch('name') }.freeze
  LAST_NAMES = CSV.read(
    File.join(DATA_DIRECTORY, 'demo_last_names.csv'), headers: true
  ).map { |row| row.fetch('name') }.freeze

  def self.full_name_at(index)
    [FIRST_NAMES.fetch(index % FIRST_NAMES.length), LAST_NAMES.fetch((index / FIRST_NAMES.length) % LAST_NAMES.length)]
  end

  def self.title_for(department, level)
    return "#{department} Manager" if level == 'Manager'

    "#{level} #{ROLES.fetch(department)}"
  end

  def self.salary_band(country)
    config = COUNTRIES.find { |entry| entry[:country] == country }
    raise ArgumentError, "Unknown demo country: #{country}" unless config

    config.slice(:currency, :minimum, :maximum)
  end

  def self.call
    if Employee.exists?
      puts 'Seed skipped: existing employee data was preserved.'
      return
    end

    random = Random.new(RANDOM_SEED)
    employee_index = 0

    Employee.transaction do
      COUNTRIES.each_with_index do |config, country_position|
        config[:headcount].times do |country_index|
          first_name, last_name = full_name_at(employee_index)
          department = DEPARTMENTS.fetch((country_index + country_position * 2) % DEPARTMENTS.length)
          level = LEVELS.fetch(employee_index % LEVELS.length)
          employee_number = format('AC%05d', employee_index + 1)
          employee = Employee.create!(
            employee_number: employee_number,
            first_name: first_name,
            last_name: last_name,
            email: "employee#{employee_index + 1}@example.test",
            country: config[:country],
            department: department,
            title: title_for(department, level)
          )
          amount = random.rand(config[:minimum]..config[:maximum])
          CurrentSalary.create!(employee: employee, amount_minor: amount, currency: config[:currency])
          employee_index += 1
        end
      end
    end

    puts "Seeded #{Employee.count} synthetic employees."
  end
end
