def word_sizes(str)
  word_count = Hash.new
  str = str.split
  array = []
  str.each do |word|
    word.
    num = word.length
    array << num
  end

  array.sort!

  array.each do |num|
    word_count[num] = array.count(num)
  end
  word_count
end

p word_sizes('Four score and seven.')
p word_sizes("What's up doc?")
p word_sizes('')
p word_sizes("Hey diddle diddle, the cat and the fiddle!")

# GIVEN the string in the parameter, SPLIT the string and
# ITERATE through each word and Set the key equal to the
# length of the word and the value equal to the frequency of the
# words in the string with that length