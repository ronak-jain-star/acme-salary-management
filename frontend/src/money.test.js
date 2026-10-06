import test from 'node:test'
import assert from 'node:assert/strict'
import { formatMoney } from './money.js'

test('formats minor units using the supplied currency', () => {
  assert.equal(formatMoney(12500000, 'USD'), 'USD\u00a0125,000')
  assert.equal(formatMoney(12500000, 'INR'), 'INR\u00a0125,000')
  assert.equal(formatMoney(9979700, 'SGD'), 'SGD\u00a099,797')
})

test('rejects invalid amounts and currency codes', () => {
  assert.throws(() => formatMoney(-1, 'USD'), TypeError)
  assert.throws(() => formatMoney(100, 'usd'), TypeError)
  assert.throws(() => formatMoney(100, 'ABC'), TypeError)
})
