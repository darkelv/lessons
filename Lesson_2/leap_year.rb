puts "Введите день"
day = gets.to_i
puts "Введите месяц"
month = gets.to_i
puts "Введите год"
year = gets.to_i

feb = year % 400 == 0 || year % 4 == 0 && year % 100 != 0 ? 29 : 28

return puts "Неправльный ввод данных" if month > 12 || day > 31

month_array = [31, feb, 31, 30, 31, 30, 31, 31, 30, 31, 30]
serial_number = month_array.first(month - 1).sum(day)

puts "Порядковй номер: #{serial_number}"
