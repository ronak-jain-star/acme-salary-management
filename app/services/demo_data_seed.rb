# frozen_string_literal: true

class DemoDataSeed
  TOTAL_EMPLOYEES = 10_000
  RANDOM_SEED = 20_260_001
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
  COUNTRIES = [
    { country: 'United States', currency: 'USD', headcount: 2_300, minimum: 5_000_000, maximum: 20_000_000 },
    { country: 'India', currency: 'INR', headcount: 2_600, minimum: 80_000_000, maximum: 600_000_000 },
    { country: 'United Kingdom', currency: 'GBP', headcount: 1_800, minimum: 3_000_000, maximum: 13_000_000 },
    { country: 'Germany', currency: 'EUR', headcount: 1_900, minimum: 3_500_000, maximum: 12_000_000 },
    { country: 'Singapore', currency: 'SGD', headcount: 1_400, minimum: 4_500_000, maximum: 18_000_000 }
  ].map(&:freeze).freeze
  FIRST_NAMES = %w[
    Avery Jordan Riley Morgan Casey Taylor Jamie Quinn Alex Cameron Devon Blake Elliot Finley
    Harper Logan Micah Parker Reese Rowan Sage Skyler Spencer Sydney Tatum Teagan Val Frankie
    Dakota Emerson Hayden Jesse Kai Lane Marley Noel Phoenix Remy Robin Sawyer Shiloh Zion
    Bailey Drew Eden Gray Jules Lennon Milan Oakley River Sam Ari Bell Ellis Kennedy Leslie
    Monroe Nico Shay Terry Amari Andy Angel Ash August Billie Briar Charlie Cody Cory Dallas
    Dani Devin Eli Erin Ezra Gale Hollis Indy Ira Jessie Kit Lee Luca Max Ollie Perry Ray Rohan
    Rory Sasha Shreya Tal Toby Uma Wren Yara Yuki Zara Adrian Aiden
  ].freeze
  LAST_NAMES = %w[
    Patel Kim Garcia Smith Brown Wilson Singh Martin Chen Taylor Davis Miller Rodriguez
    Martinez Anderson Thomas Moore Jackson Thompson White Lopez Lee Gonzalez Harris Clark Lewis
    Robinson Walker Perez Hall Young Allen King Wright Scott Torres Nguyen Hill Flores Green
    Adams Nelson Baker Mitchell Carter Roberts Phillips Campbell Evans Turner Diaz Edwards
    Collins Stewart Morris Morales Murphy Cook Rogers Gutierrez Ortiz Cooper Peterson Bailey
    Reed Kelly Howard Ramos Ward Cox Richardson Watson Brooks Bennett Wood Barnes Ross
    Henderson Coleman Jenkins Perry Powell Long Patterson Hughes Alvarez Atkinson Black Bryant
    Butler Chavez Curtis Fisher Ford Foster Graham Holmes Hudson James Jordan Lawson Marshall
    Matthews Myers Nichols Palmer Porter Price Reynolds Rice Simmons Stone Sullivan Wells West
    Woods Xu Yang Zhao Zimmerman
  ].freeze

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
