require "rails_helper"

RSpec.describe EmployeeDirectory do
  describe ".call" do
    it "filters employees and returns sorted paginated results with metadata" do
      create(:employee, first_name: "Zoey", last_name: "Zebra", country: "India", department: "Engineering")
      expected_employee = create(:employee, first_name: "Avery", last_name: "Adams", country: "India",
department: "Engineering")
      create(:employee, country: "India", department: "Finance")
      create(:employee, country: "United States", department: "Engineering")

      result = described_class.call(page: "1", per_page: "1", query: "India", country: "India",
department: "Engineering")

      expect(result.employees).to contain_exactly(expected_employee)
      expect(result).to have_attributes(page: 1, per_page: 1, total: 2)
    end

    it "uses defaults and clamps page and page size to supported bounds" do
      create_list(:employee, 2)

      defaults = described_class.call
      clamped = described_class.call(page: "0", per_page: "500")

      expect(defaults).to have_attributes(page: 1, per_page: 25, total: 2)
      expect(clamped).to have_attributes(page: 1, per_page: 100, total: 2)
    end

    it "returns the requested page of alphabetically ordered employees" do
      second = create(:employee, first_name: "Avery", last_name: "Brown")
      create(:employee, first_name: "Jordan", last_name: "Adams")
      create(:employee, first_name: "Morgan", last_name: "Clark")

      result = described_class.call(page: 2, per_page: 1)

      expect(result.employees).to contain_exactly(second)
      expect(result.total).to eq(3)
    end
  end
end
