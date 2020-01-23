puts "Введите день"
day = gets.to_i
puts "Введите месяц"
month = gets.to_i
puts "Введите год"
year = gets.to_i

if year % 400 == 0
  feb = 29
elsif year % 4 == 0 && year % 100 != 0
  feb = 29
else
  feb = 28
end

return puts "Неправльный ввод данных" if month > 12 || day > 31

month_array = [31, feb, 31, 30, 31, 30, 31, 31, 30, 31, 30]
serial_number = month_array.first(month - 1).sum(day)

puts "Порядковй номер: #{serial_number}"
