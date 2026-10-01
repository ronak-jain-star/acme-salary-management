FactoryBot.define do
  factory :current_salary do
    employee
    amount_minor { 10_000_000 }
    currency { "USD" }
  end
end
