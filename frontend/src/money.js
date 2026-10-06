export function formatMoney(minorUnits, currency) {
  if (!Number.isSafeInteger(minorUnits) || minorUnits < 0) throw new TypeError('minorUnits must be a non-negative safe integer')
  if (!['USD', 'INR', 'GBP', 'EUR', 'SGD'].includes(currency)) throw new TypeError('currency must be one of USD, INR, GBP, EUR, SGD')
  return new Intl.NumberFormat('en', {
    style: 'currency',
    currency,
    currencyDisplay: 'narrowSymbol',
    maximumFractionDigits: 0
  }).format(minorUnits / 100)
}
