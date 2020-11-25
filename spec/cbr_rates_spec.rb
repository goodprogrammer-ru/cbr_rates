RSpec.describe CbrRates do
  let(:rates) do
    date = Date.parse('26.11.2020')
    CbrRates.new(date)
  end

  describe '#rate' do
    it 'returns rate for certain date & currency' do
      expect(rates.rate('USD')).to eq 75.4727
    end
  end

  describe '#exchange' do
    it 'converts another currency to rubles' do
      usd = Money.new('1_00', 'USD')

      result = rates.exchange(usd, 'RUB')

      expect(result).to eq Money.new(75_47, 'RUB')
    end

    it 'converts one currency to another currency' do
      aud = Money.new('1_50', 'AUD')

      result = rates.exchange(aud, 'USD')

      expect(result).to eq Money.new(1_10, 'USD')
    end
  end
end
