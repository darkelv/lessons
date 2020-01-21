puts "Введите ваше Имя"
name = gets.chomp

puts "Введите ваш рост"
height = gets.to_i

ideal_weight = (height - 110)*1.15

if ideal_weight > 0
	puts "#{name}, Ваш идеальный вес #{ideal_weight.to_i}"
else
	puts "#{name}, Ваш вес уже оптимальный"
end