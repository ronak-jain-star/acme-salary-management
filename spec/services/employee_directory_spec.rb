require "rails_helper"

RSpec.describe EmployeeDirectory do
  describe ".call" do
    before_all do
      create(:employee, first_name: "Zoey", last_name: "Zebra", country: "India", department: "Engineering")
      @adams = create(:employee, first_name: "Avery", last_name: "Adams", country: "India", department: "Engineering")
      create(:employee, country: "India", department: "Finance")
      @brown = create(:employee, first_name: "Jordan", last_name: "Brown", country: "United States",
department: "Engineering")
    end

    it "filters employees and returns sorted paginated results with metadata" do
      result = described_class.call(page: "1", per_page: "1", query: "India", country: "India",
department: "Engineering")

      expect(result.employees).to contain_exactly(@adams)
      expect(result).to have_attributes(page: 1, per_page: 1, total: 2)
    end

    it "uses defaults and clamps page and page size to supported bounds" do
      defaults = described_class.call
      clamped = described_class.call(page: "0", per_page: "500")

      expect(defaults).to have_attributes(page: 1, per_page: 25, total: 4)
      expect(clamped).to have_attributes(page: 1, per_page: 100, total: 4)
    end

    it "returns the requested page of alphabetically ordered employees" do
      result = described_class.call(page: 2, per_page: 1)

      expect(result.employees).to contain_exactly(@brown)
      expect(result.total).to eq(4)
    end
  end
end
