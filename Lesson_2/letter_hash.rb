letter_hash = {}
step = 1

(:a..:z).each do |letter|
  letter_hash[letter] = step if [:a, :e, :i, :o, :u].include?(letter)
  step += 1
end

puts letter_hash
