# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ['Action', 'Comedy', 'Drama', 'Horror'].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Deterministic, synthetic demo data. Rerunning replaces only this app's rows.
unless Employee.exists?
  srand(20_260_001)

  countries = [
    ['United States', 'USD', 5_000_000, 20_000_000],
    ['India', 'INR', 80_000_000, 600_000_000],
    ['United Kingdom', 'GBP', 3_000_000, 15_000_000],
    ['Germany', 'EUR', 3_500_000, 14_000_000],
    ['Singapore', 'SGD', 4_000_000, 18_000_000]
  ]
  departments = ['Engineering', 'People', 'Finance', 'Sales', 'Operations', 'Product', 'Design']
  first_names = %w[
    Avery Jordan Riley Morgan Casey Taylor Jamie Quinn Alex Cameron Devon Blake Elliot Finley Harper Logan
    Micah Parker Reese Rowan Sage Skyler Spencer Sydney Tatum Teagan Val Frankie Dakota Emerson Hayden Jesse
    Kai Lane Marley Noel Phoenix Remy Robin Sawyer Shiloh Zion Bailey Drew Eden Gray Jules Lennon Milan Oakley
    River Sam Ari Bell Ellis Kennedy Leslie Monroe Nico Shay Terry
  ]
  last_names = %w[
    Patel Kim Garcia Smith Brown Wilson Singh Martin Chen Taylor Davis Miller Rodriguez Martinez Anderson Thomas
    Moore Jackson Thompson White Lopez Lee Gonzalez Harris Clark Lewis Robinson Walker Perez Hall Young Allen
    King Wright Scott Torres Nguyen Hill Flores Green Adams Nelson Baker Mitchell Carter Roberts Phillips Campbell
    Evans Turner Diaz Edwards Collins Stewart Morris Morales Murphy Cook Rogers Gutierrez Ortiz Cooper Peterson
    Bailey Reed Kelly Howard Ramos Ward Cox Richardson Watson Brooks Bennett Wood Barnes Ross Henderson Coleman
    Jenkins Perry Powell Long Patterson Hughes
  ]
  titles = ['Associate', 'Senior', 'Lead', 'Staff', 'Manager']

  Employee.transaction do
    10_000.times do |index|
      country, currency, minimum_salary, maximum_salary = countries[index % countries.length]
      department = departments[(index / countries.length) % departments.length]
      first = first_names[index % first_names.length]
      last = last_names[(index / first_names.length) % last_names.length]
      employee = Employee.create!(
        employee_number: format('AC%05d', index + 1),
        first_name: first,
        last_name: last,
        email: "employee#{index + 1}@example.test",
        country: country,
        department: department,
        title: "#{department} #{titles[index % titles.length]}"
      )
      amount = rand(minimum_salary..maximum_salary)
      CurrentSalary.create!(employee: employee, amount_minor: amount, currency: currency)
    end
  end
  puts "Seeded #{Employee.count} synthetic employees."
else
  puts 'Seed skipped: existing employee data was preserved.'
end
