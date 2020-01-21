params = []
3.times do
	puts "Введите коэфицент:"
	params << gets.to_f
end

a,b,c = params

d = b**2 - 4 * a * c

if d < 0
	puts "Корней нет"
elsif d == 0
	root = -b/(2 * a)
	puts "Ответ дикскриминант равен #{b} коернь равен #{root.round(2)}"
else
	sqrt_d = Math.sqrt(d)
	first_root = (-b + sqrt_d)/(2 * a)
	second_root = (-b - sqrt_d)/(2 * a)
	puts "Ответ первый корень #{first_root.round(2)}, второй корень #{second_root.round(2)}"
end
