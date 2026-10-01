require "rails_helper"

RSpec.describe "Employees API", type: :request do
  it "searches employees and caps page size" do
    employee = create(:employee, first_name: "Jordan", last_name: "Kim")
    create_list(:employee, 2)
    get "/api/v1/employees", params: { q: "Jordan", per_page: 500 }
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)).to include("total" => 1, "per_page" => 100)
    expect(JSON.parse(response.body).fetch("employees").first.fetch("id")).to eq(employee.id)
  end

  it "returns insights separated by currency" do
    employee = create(:employee)
    employee.current_salary.update!(currency: "INR", amount_minor: 7_000_000)
    get "/api/v1/insights"
    groups = JSON.parse(response.body).fetch("groups")
    expect(groups.map { |g| g.fetch("currency") }).to include("INR")
  end
end
