require 'rails_helper'

RSpec.describe DemoDataSeed do
  describe 'seed plan' do
    it 'allocates 10,000 employees across different country headcounts' do
      headcounts = described_class::COUNTRIES.map { |country| country[:headcount] }

      expect(headcounts.sum).to eq(10_000)
      expect(headcounts.uniq.length).to be > 1
    end

    it 'uses country-specific salary bands and currencies' do
      india = described_class.salary_band('India')
      singapore = described_class.salary_band('Singapore')
      united_kingdom = described_class.salary_band('United Kingdom')
      germany = described_class.salary_band('Germany')

      expect(india).to eq({ currency: 'INR', minimum: 80_000_000, maximum: 600_000_000 })
      expect(singapore).to eq({ currency: 'SGD', minimum: 4_500_000, maximum: 18_000_000 })
      expect(united_kingdom[:maximum]).not_to eq(germany[:maximum])
      expect { described_class.salary_band('Unknown') }.to raise_error(ArgumentError)
    end

    it 'generates unique names for the full seeded population' do
      names = (0...described_class::TOTAL_EMPLOYEES).map do |index|
        described_class.full_name_at(index).join(' ')
      end

      expect(names.uniq.length).to eq(described_class::TOTAL_EMPLOYEES)
    end

    it 'formats job titles with natural role wording' do
      expect(described_class.title_for('Engineering', 'Senior')).to eq('Senior Engineer')
      expect(described_class.title_for('Design', 'Manager')).to eq('Design Manager')
    end
  end
end
