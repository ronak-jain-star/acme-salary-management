import test from 'node:test'
import assert from 'node:assert/strict'
import { formatMoney } from './money.js'

test('formats minor units using the supplied currency', () => {
  assert.equal(formatMoney(12500000, 'USD'), '$125,000')
  assert.equal(formatMoney(12500000, 'INR'), '₹125,000')
})

test('rejects invalid amounts and currency codes', () => {
  assert.throws(() => formatMoney(-1, 'USD'), TypeError)
  assert.throws(() => formatMoney(100, 'usd'), TypeError)
})
