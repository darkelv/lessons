fibonachi_array = [0]
array_item = 1

while array_item < 100
  fibonachi_array << array_item
  array_item = fibonachi_array[-2] + fibonachi_array[-1]
end

puts fibonachi_array
