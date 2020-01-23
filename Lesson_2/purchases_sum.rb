purchases = {}
loop do
  puts "Введите название товара: "
  name = gets.chomp
  break if name == "стоп"
  puts "Введите цену за единицу товара: "
  price = gets.to_f
  puts "Введите количество купленного товара"
  amount = gets.to_f
  purchases[name] = { price: price, amount: amount}
end

puts "Список всех покупок #{purchases}"

purchases_sum = []
purchases.each do |name, attributes|
  item_sum = attributes[:price] * attributes[:amount]
  purchases_sum << item_sum
  puts "#{name} стоимость: #{item_sum}"
end

puts "Сумма всех покупок #{purchases_sum.sum}"
