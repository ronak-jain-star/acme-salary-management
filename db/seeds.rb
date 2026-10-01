# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Deterministic, synthetic demo data. Rerunning replaces only this app's rows.
unless Employee.exists?
srand(20_260_001)

countries = [ [ "United States", "USD" ], [ "India", "INR" ], [ "United Kingdom", "GBP" ], [ "Germany", "EUR" ],
[ "Singapore", "SGD" ]
]
departments = [ "Engineering", "People", "Finance", "Sales", "Operations", "Product", "Design" ]
first_names = %w[Avery Jordan Riley Morgan Casey Taylor Jamie Quinn Alex Cameron]
last_names = %w[Patel Kim Garcia Smith Brown Wilson Singh Martin Chen Taylor]
titles = [ "Associate", "Senior", "Lead", "Staff", "Manager" ]

Employee.transaction do
  10_000.times do |index|
    country, currency = countries[index % countries.length]
    department = departments[(index / countries.length) % departments.length]
    first = first_names[index % first_names.length]
    last = last_names[(index / first_names.length) % last_names.length]
    employee = Employee.create!(employee_number: format("AC%05d", index + 1), first_name: first, last_name: last,
      email: "employee#{index + 1}@example.test", country: country, department: department,
      title: "#{titles[index % titles.length]} #{department}")
    amount = 4_000_000 + rand(12_000_000)
    CurrentSalary.create!(employee: employee, amount_minor: amount, currency: currency)
  end
end
puts "Seeded #{Employee.count} synthetic employees."
else
  puts "Seed skipped: existing employee data was preserved."
end
