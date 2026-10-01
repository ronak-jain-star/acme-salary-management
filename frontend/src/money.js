export function formatMoney(minorUnits, currency) {
  if (!Number.isSafeInteger(minorUnits) || minorUnits < 0) throw new TypeError('minorUnits must be a non-negative safe integer')
  if (!/^[A-Z]{3}$/.test(currency)) throw new TypeError('currency must be a three-letter uppercase code')
  return new Intl.NumberFormat('en', { style: 'currency', currency, maximumFractionDigits: 0 }).format(minorUnits / 100)
}
