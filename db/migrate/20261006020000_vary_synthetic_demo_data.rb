# frozen_string_literal: true

class VarySyntheticDemoData < ActiveRecord::Migration[7.1]
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

  def up
    update_synthetic_titles
    redistribute_synthetic_employees
    redistribute_synthetic_salaries
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def update_synthetic_titles
    index = employee_index
    level = "((ARRAY['Associate', 'Senior', 'Lead', 'Staff', 'Manager'])[(#{index} % 5) + 1])"
    role = <<~SQL.squish
      CASE department
        WHEN 'Engineering' THEN 'Engineer'
        WHEN 'People' THEN 'People Partner'
        WHEN 'Finance' THEN 'Finance Analyst'
        WHEN 'Sales' THEN 'Sales Representative'
        WHEN 'Operations' THEN 'Operations Specialist'
        WHEN 'Product' THEN 'Product Specialist'
        WHEN 'Design' THEN 'Designer'
      END
    SQL

    execute <<~SQL
      UPDATE employees
      SET title = CASE
        WHEN #{level} = 'Manager' THEN department || ' Manager'
        ELSE #{level} || ' ' || (#{role})
      END,
      updated_at = CURRENT_TIMESTAMP
      WHERE email LIKE 'employee%@example.test'
    SQL
  end

  def redistribute_synthetic_employees
    source_index = employee_index
    index = 'employee_index'
    country = country_expression(index)
    local_index = local_index_expression(index)
    department_values = "ARRAY['Engineering', 'People', 'Finance', 'Sales', " \
                        "'Operations', 'Product', 'Design']"
    department = "(#{department_values})[(#{local_index} % 7) + 1]"
    first_name = "(#{sql_array(FIRST_NAMES)})[(#{index} % #{FIRST_NAMES.length}) + 1]"
    last_name = "(#{sql_array(LAST_NAMES)})[((#{index} / #{FIRST_NAMES.length}) % #{LAST_NAMES.length}) + 1]"
    level = "((ARRAY['Associate', 'Senior', 'Lead', 'Staff', 'Manager'])[(#{index} % 5) + 1])"
    role = <<~SQL.squish
      CASE #{department}
        WHEN 'Engineering' THEN 'Engineer'
        WHEN 'People' THEN 'People Partner'
        WHEN 'Finance' THEN 'Finance Analyst'
        WHEN 'Sales' THEN 'Sales Representative'
        WHEN 'Operations' THEN 'Operations Specialist'
        WHEN 'Product' THEN 'Product Specialist'
        WHEN 'Design' THEN 'Designer'
      END
    SQL

    execute <<~SQL
      WITH eligible AS (
        SELECT id, #{source_index} AS employee_index
        FROM employees
        WHERE email LIKE 'employee%@example.test'
          AND NOT EXISTS (
            SELECT 1
            FROM salary_histories
            WHERE salary_histories.employee_id = employees.id
          )
      ), mapped AS (
        SELECT id,
               #{first_name} AS first_name,
               #{last_name} AS last_name,
               #{country} AS country,
               #{department} AS department,
               CASE
                 WHEN #{level} = 'Manager' THEN (#{department}) || ' Manager'
                 ELSE (#{level}) || ' ' || (#{role})
               END AS title
        FROM eligible
      )
      UPDATE employees
      SET country = mapped.country,
          first_name = mapped.first_name,
          last_name = mapped.last_name,
          department = mapped.department,
          title = mapped.title,
          updated_at = CURRENT_TIMESTAMP
      FROM mapped
      WHERE employees.id = mapped.id
    SQL
  end

  def redistribute_synthetic_salaries
    index = employee_index
    country = country_expression(index)
    currency = <<~SQL.squish
      CASE #{country}
        WHEN 'United States' THEN 'USD'
        WHEN 'India' THEN 'INR'
        WHEN 'United Kingdom' THEN 'GBP'
        WHEN 'Germany' THEN 'EUR'
        WHEN 'Singapore' THEN 'SGD'
      END
    SQL
    minimum = salary_value_expression(index, :minimum)
    maximum = salary_value_expression(index, :maximum)

    execute <<~SQL
      WITH mapped AS (
        SELECT employees.id,
               #{currency} AS currency,
               #{minimum} AS minimum_salary,
               #{maximum} AS maximum_salary,
               #{index} AS employee_index
        FROM employees
        WHERE employees.email LIKE 'employee%@example.test'
          AND NOT EXISTS (
            SELECT 1
            FROM salary_histories
            WHERE salary_histories.employee_id = employees.id
          )
      )
      UPDATE current_salaries AS salaries
      SET currency = mapped.currency,
          amount_minor = mapped.minimum_salary +
            ((mapped.employee_index * 104_729 + 101) %
              (mapped.maximum_salary - mapped.minimum_salary + 1)),
          updated_at = CURRENT_TIMESTAMP
      FROM mapped
      WHERE salaries.employee_id = mapped.id
    SQL
  end

  def employee_index
    '(substring(employee_number from 3)::integer - 1)'
  end

  def country_expression(index)
    <<~SQL.squish
      CASE
        WHEN #{index} < 2300 THEN 'United States'
        WHEN #{index} < 4900 THEN 'India'
        WHEN #{index} < 6700 THEN 'United Kingdom'
        WHEN #{index} < 8600 THEN 'Germany'
        ELSE 'Singapore'
      END
    SQL
  end

  def local_index_expression(index)
    <<~SQL.squish
      CASE
        WHEN #{index} < 2300 THEN #{index}
        WHEN #{index} < 4900 THEN #{index} - 2300 + 2
        WHEN #{index} < 6700 THEN #{index} - 4900 + 4
        WHEN #{index} < 8600 THEN #{index} - 6700 + 6
        ELSE #{index} - 8600 + 8
      END
    SQL
  end

  def salary_value_expression(index, bound)
    values = {
      minimum: [5_000_000, 80_000_000, 3_000_000, 3_500_000, 4_500_000],
      maximum: [20_000_000, 600_000_000, 13_000_000, 12_000_000, 18_000_000]
    }.fetch(bound)
    country_boundaries = [2300, 4900, 6700, 8600]
    clauses = country_boundaries.each_with_index.map do |boundary, position|
      "WHEN #{index} < #{boundary} THEN #{values[position]}"
    end
    clauses << "ELSE #{values.last}"
    "CASE #{clauses.join(' ')} END"
  end

  def sql_array(values)
    "ARRAY[#{values.map { |value| connection.quote(value) }.join(', ')}]"
  end
end
