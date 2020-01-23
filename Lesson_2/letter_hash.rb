letter_hash = {}
step = 1
letter_array = [:a, :e, :i, :o, :u]
(:a..:z).each.with_index(1) do |letter, index|
  letter_hash[letter] = index if letter_array.include?(letter)
end

puts letter_hash
