class RefreshSyntheticDemoData < ActiveRecord::Migration[7.1]
  FIRST_NAMES = %w[
    Avery Jordan Riley Morgan Casey Taylor Jamie Quinn Alex Cameron Devon Blake Elliot Finley Harper
    Logan Micah Parker Reese Rowan Sage Skyler Spencer Sydney Tatum Teagan Val Frankie Dakota Emerson
    Hayden Jesse Kai Lane Marley Noel Phoenix Remy Robin Sawyer Shiloh Zion Bailey Drew Eden Gray
    Jules Lennon Milan Oakley River Sam Ari Bell Ellis Kennedy Leslie Monroe Nico Shay Terry
  ].freeze
  LAST_NAMES = %w[
    Patel Kim Garcia Smith Brown Wilson Singh Martin Chen Taylor Davis Miller Rodriguez Martinez
    Anderson Thomas Moore Jackson Thompson White Lopez Lee Gonzalez Harris Clark Lewis Robinson
    Walker Perez Hall Young Allen King Wright Scott Torres Nguyen Hill Flores Green Adams Nelson
    Baker Mitchell Carter Roberts Phillips Campbell Evans Turner Diaz Edwards Collins Stewart Morris
    Morales Murphy Cook Rogers Gutierrez Ortiz Cooper Peterson Bailey Reed Kelly Howard Ramos Ward
    Cox Richardson Watson Brooks Bennett Wood Barnes Ross Henderson Coleman Jenkins Perry Powell Long
    Patterson Hughes
  ].freeze
  TITLES = %w[Associate Senior Lead Staff Manager].freeze

  def up
    refresh_synthetic_names_and_titles
    scale_synthetic_salaries
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def refresh_synthetic_names_and_titles
    employee_index = '(substring(employee_number from 3)::integer - 1)'
    first_index = "(#{employee_index} % #{FIRST_NAMES.length}) + 1"
    last_index = "((#{employee_index} / #{FIRST_NAMES.length}) % #{LAST_NAMES.length}) + 1"
    title_index = "(#{employee_index} % #{TITLES.length}) + 1"

    execute <<~SQL
      UPDATE employees
      SET first_name = names.first_name,
          last_name = names.last_name,
          title = names.department || ' ' || names.title,
          updated_at = CURRENT_TIMESTAMP
      FROM (
        SELECT id,
               department,
               (#{sql_array(FIRST_NAMES)})[#{first_index}] AS first_name,
               (#{sql_array(LAST_NAMES)})[#{last_index}] AS last_name,
               (#{sql_array(TITLES)})[#{title_index}] AS title
        FROM employees
        WHERE email LIKE 'employee%@example.test'
      ) AS names
      WHERE employees.id = names.id
    SQL
  end

  def scale_synthetic_salaries
    execute <<~SQL
      UPDATE current_salaries AS salaries
      SET amount_minor = CASE employees.country
        WHEN 'India' THEN salaries.amount_minor * 35
        WHEN 'United States' THEN salaries.amount_minor * 5 / 4
        ELSE salaries.amount_minor
      END,
      updated_at = CURRENT_TIMESTAMP
      FROM employees
      WHERE salaries.employee_id = employees.id
        AND employees.email LIKE 'employee%@example.test'
        AND employees.country IN ('India', 'United States')
        AND NOT EXISTS (
          SELECT 1
          FROM salary_histories
          WHERE salary_histories.employee_id = employees.id
        )
    SQL
  end

  def sql_array(values)
    "ARRAY[#{values.map { |value| connection.quote(value) }.join(', ')}]"
  end
end
