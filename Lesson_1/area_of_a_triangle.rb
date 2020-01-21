puts "Введите основание треугольника"
base = gets.to_i

puts "Введите высоту треугольника"
height = gets.to_i

area = 0.5*base*height

puts "Площадь треугольника #{area.round(2)}"