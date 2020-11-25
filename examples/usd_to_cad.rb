require_relative '../lib/cbr_rates'

Money.locale_backend = :currency

usd = Money.new('1_50', 'USD')

result = CbrRates.new.exchange(usd, 'CAD')

puts "1.50 USD -> CAD: #{result.format}"
