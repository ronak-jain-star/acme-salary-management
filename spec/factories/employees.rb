FactoryBot.define do
  factory :employee do
    sequence(:employee_number) { |n| "AC#{format('%05d', n)}" }
    first_name { "Avery" }
    last_name { "Patel" }
    sequence(:email) { |n| "employee#{n}@example.test" }
    country { "United States" }
    department { "Engineering" }
    title { "Senior Engineer" }
    after(:create) { |employee| create(:current_salary, employee: employee) }
  end
end
