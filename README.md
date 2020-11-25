# Котировки валют с Банка России

## Установка

Добавьте

``` rb
gem 'cbr_rates'
```

И сделайте

    bundle

Или сделайте

    gem install cbr_rates

## Использование

``` rb
require 'cbr_rates'

usd = Money.new('1_50', 'USD')

result = CbrRates.new.exchange(usd, 'CAD')

puts "1.50 USD -> CAD: #{result.format}"
```

Как обращаться с объектом `Money` см. в [документации](https://github.com/RubyMoney/money) этого гема.

## Помочь в разработке

Шлите ваши пулреквесты в https://github.com/goodprogrammer-ru/cbr_rates.

## Лицензия

[MIT License](https://opensource.org/licenses/MIT)
