require 'rails_helper'

RSpec.describe 'Employees API', type: :request do
  before_all do
    @search_employee = create(:employee, first_name: 'Jordan', last_name: 'Kim')
    create_list(:employee, 2)
    @insights_employee = create(:employee)
    @insights_employee.current_salary.update!(currency: 'INR', amount_minor: 7_000_000)
    create(:employee, first_name: 'Siri', country: 'United Kingdom', department: 'Sales')
    create(:employee, first_name: 'Alex', country: 'United Kingdom', department: 'Sales')
    create(:employee, first_name: 'Siri', country: 'India', department: 'Sales')
    @salary_employee = create(:employee)
  end

  it 'searches employees and caps page size' do
    get '/api/v1/employees', params: { q: 'Jordan', per_page: 500 }
    expect(response).to have_http_status(:ok)
    payload = JSON.parse(response.body)
    expect(payload.fetch('metadata')).to include('total' => 1, 'per_page' => 100)
    serialized_employee = payload.fetch('data').fetch('employees').first
    expect(serialized_employee).to include(
      'id' => @search_employee.id,
      'name' => 'Jordan Kim',
      'salary' => { 'amount_minor' => 10_000_000, 'currency' => 'USD' }
    )
  end

  it 'returns insights separated by currency' do
    get '/api/v1/insights'
    groups = JSON.parse(response.body).fetch('data').fetch('groups')
    currency_groups = groups.select do |group|
      group.fetch('country') == 'United States' && group.fetch('department') == 'Engineering'
    end
    expect(currency_groups.map { |group| group.fetch('currency') }).to contain_exactly('USD', 'INR')
  end

  it 'applies the same search and filters to salary insights' do
    get '/api/v1/insights', params: { q: 'Siri', country: 'United Kingdom', department: 'Sales' }
    groups = JSON.parse(response.body).fetch('data').fetch('groups')

    expect(groups.map { |group| [group.fetch('country'), group.fetch('department'), group.fetch('headcount')] })
      .to contain_exactly(['United Kingdom', 'Sales', 1])
  end

  it 'updates salary and returns an audit reference' do
    employee = @salary_employee
    post "/api/v1/employees/#{employee.id}/salary_changes",
         params: {
           changed_by: 'Unverified Caller',
           salary: { amount_minor: 11_000_000, currency: 'USD', reason: 'Merit increase' }
         },
         as: :json
    expect(response).to have_http_status(:created)
    expect(employee.current_salary.reload.amount_minor).to eq(11_000_000)
    expect(employee.salary_histories.count).to eq(1)

    get "/api/v1/employees/#{employee.id}/salary_history"
    history = JSON.parse(response.body).fetch('data').first
    expect(history).to include(
      'new_amount_minor' => 11_000_000,
      'currency' => 'USD',
      'reason' => 'Merit increase',
      'changed_by' => 'HR Manager'
    )
  end
end
