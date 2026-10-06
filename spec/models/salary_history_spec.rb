require 'rails_helper'

RSpec.describe SalaryHistory do
  let(:employee) { create(:employee) }
  let(:history) do
    employee.salary_histories.create!(
      previous_amount_minor: 10_000_000,
      previous_currency: 'USD',
      new_amount_minor: 11_000_000,
      currency: 'USD',
      reason: 'Merit increase',
      changed_by: 'HR Manager'
    )
  end

  it 'rejects updates to an existing salary history row' do
    expect { history.update!(reason: 'Changed reason') }
      .to raise_error(ActiveRecord::ReadOnlyRecord, 'salary history is immutable')
  end

  it 'rejects deletion of an existing salary history row' do
    expect { history.destroy! }
      .to raise_error(ActiveRecord::ReadOnlyRecord, 'salary history is immutable')
  end
end
