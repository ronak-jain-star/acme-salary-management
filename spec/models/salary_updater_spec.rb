require "rails_helper"

RSpec.describe SalaryUpdater do
  let(:employee) { create(:employee) }

  it "updates salary and appends an audit row" do
    result = described_class.call(employee: employee, amount_minor: "12500000", currency: "USD", reason: "Merit increase", changed_by: "HR")
    expect(result).to be_success
    expect(employee.current_salary.reload.amount_minor).to eq(12_500_000)
    expect(employee.salary_changes.count).to eq(1)
    expect(employee.salary_changes.first).to have_attributes(previous_amount_minor: 10_000_000, previous_currency: "USD", new_amount_minor: 12_500_000, currency: "USD", reason: "Merit increase", changed_by: "HR")
  end

  it "rejects invalid amount without changing salary" do
    result = described_class.call(employee: employee, amount_minor: "-1", currency: "USD", reason: "Correction", changed_by: "HR")
    expect(result).not_to be_success
    expect(employee.current_salary.reload.amount_minor).to eq(10_000_000)
    expect(employee.salary_changes).to be_empty
  end

  it "requires a reason and a three-letter currency code" do
    result = described_class.call(employee: employee, amount_minor: "1", currency: "US dollars", reason: " ", changed_by: "HR")
    expect(result.errors).to include("currency must be a three-letter code", "reason is required (max 500 characters)")
  end
end
