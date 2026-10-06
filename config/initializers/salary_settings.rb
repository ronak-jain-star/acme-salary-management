module SalarySettings
  DEFAULT_CURRENCIES = %w[USD INR GBP EUR SGD].freeze

  def self.supported_currencies
    configured = Figaro.env.supported_currencies.to_s.split(',').map { |currency|
 currency.strip.upcase }.reject(&:blank?)
    configured.presence || DEFAULT_CURRENCIES
  end
end
