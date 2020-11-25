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
