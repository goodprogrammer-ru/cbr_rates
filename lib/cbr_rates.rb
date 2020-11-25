require_relative 'cbr_rates/version'

require 'open-uri'
require 'money'
require 'nokogiri'

Money.rounding_mode = BigDecimal::ROUND_HALF_EVEN
Money.locale_backend = :currency

class CbrRates
  attr_reader :refreshed_at

  def initialize(date = Date.today)
    @refreshed_at = Time.now

    parse!(date)
  end

  def rate(currency_code)
    @rates[currency_code.upcase]
  end

  def exchange(money, currency_to)
    currency_from = money.currency.iso_code

    money.with_currency(currency_to) * rate(currency_from) / rate(currency_to)
  end

  private

  def parse!(date)
    date_string = date.strftime('%d/%m/%Y')
    url =
      "http://www.cbr.ru/scripts/XML_daily.asp?date_req=#{date_string}"

    response = URI.open(url).read
    xml_doc = Nokogiri::XML(response)

    result =
      xml_doc.css('Valute').map do |node|
        value = BigDecimal(node.css('Value').text.gsub(',', '.'), 10)
        amount = node.css('Nominal').text.to_i

        [
          node.css('CharCode').text,
          value / amount
        ]
      end

    result.push(["RUB", 1])

    @rates = result.to_h
  end
end

# cbr = CBRates.new
# Скачать курсы валют за сегодня

# cbr = CBRates.new(5.days.ago)
# Скачать курсы за конкретную дату

# cbr.refreshed_at
# => 2020-11-25 17:13:28

# cbr.rate("USD", "RUB")
# => 75.4727

# cbr.exchange(Money.new(100_00, "RUB"), "USD")
# => #<Money#... 1.25 USD>
