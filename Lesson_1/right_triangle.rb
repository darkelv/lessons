sides = []

3.times do
  puts "Введите cторону треугольника"
  sides << gets.to_f
end

return puts "Треугольник равносторонний и равнобедренный" if sides.uniq.length == 1

first_side, second_side, third_side = sides.sort

if first_side == second_side && first_side**2 + second_side**2 == third_side**2
  puts "Треугольник является прямоугольным и равнобедренным."
elsif first_side**2 + second_side**2 == third_side**2
  puts "Треугольник является прямоугольным."
else
  puts "Треугольник не является прямоугольным"
end
