puts "Введите основание треугольника"
base = gets.to_f

puts "Введите высоту треугольника"
height = gets.to_f

area = 0.5 * base * height

puts "Площадь треугольника #{area.round(2)}"
